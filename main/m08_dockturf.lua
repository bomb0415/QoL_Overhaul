---------------------------------------------------------------------
-- 模块：码头可铺设地皮（m08_dockturf）
-- 作者：落叶异世之力
-- 参考：码头可铺设地皮
---------------------------------------------------------------------

local ENABLED = GetModConfigData("turf_on_dock")
if not ENABLED then return end

---------------------------------------------------------------------
-- 1) 给世界添加 overtile 组件
---------------------------------------------------------------------
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("overtile")
end)

---------------------------------------------------------------------
-- 2) 所有地皮支持部署在码头地板上
---------------------------------------------------------------------
AddPrefabPostInitAny(function(inst)
    if not inst:HasTag("groundtile") or inst.prefab == "dock_kit" then
        return
    end

    -- 部署判断：允许码头地板
    local parent_candeploy = inst._custom_candeploy_fn
    inst._custom_candeploy_fn = function(inst, pt, ...)
        if TheWorld.Map:GetTileAtPoint(pt:Get()) == WORLD_TILES.MONKEY_DOCK then
            return true
        end
        return parent_candeploy and parent_candeploy(inst, pt, ...)
            or TheWorld.Map:CanPlaceTurfAtPoint(pt:Get())
    end

    if not TheWorld.ismastersim then return end

    -- 覆盖部署：铺在码头上时记录覆盖层
    inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
    inst.components.deployable.ondeploy = function(inst, pt, deployer)
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
        end

        local map = TheWorld.Map
        local x, y = map:GetTileCoordsAtPoint(pt:Get())
        local current = map:GetTileAtPoint(pt:Get())

        if current == WORLD_TILES.MONKEY_DOCK then
            TheWorld.components.overtile:SetTileAbove(x, y, inst.tile)
        end

        map:SetTile(x, y, inst.tile or WORLD_TILES.DIRT)
        inst.components.stackable:Get():Remove()
    end

    -- 3) 铲地皮后恢复码头地板
    inst:DoTaskInTime(0, function()
        if TheWorld.components.overtile == nil then return end

        local x, y, z = inst.Transform:GetWorldPosition()
        local tile_x, tile_y = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
        local above = TheWorld.components.overtile:GetTileAbove(tile_x, tile_y)

        -- 如果是码头上的地皮被铲了 → 恢复码头地板并清除记录
        if above ~= nil and TheWorld.Map:GetTile(tile_x, tile_y) ~= WORLD_TILES.MONKEY_DOCK then
            TheWorld.Map:SetTile(tile_x, tile_y, WORLD_TILES.MONKEY_DOCK)
            TheWorld.components.overtile:ClearTileAbove(tile_x, tile_y)
        end
    end)
end)

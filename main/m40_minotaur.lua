---------------------------------------------------------------------
-- 模块 m40_minotaur：犀牛必爆懒人法杖
-- 来源：m30_daily.lua
-- 功能：远古守护者必掉懒人法杖（替代原来的掉落机制）
---------------------------------------------------------------------

AddPrefabPostInit("minotaurchestspawner", function(inst)
    if not TheWorld.ismastersim then return end

    local function remove_staffs_from_chest()
        inst:DoTaskInTime(0.1, function()
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 30, { "treasurechest" })
            for _, chest in ipairs(ents) do
                if chest.components.container then
                    for i = chest.components.container.numslots, 1, -1 do
                        local item = chest.components.container.slots[i]
                        if item and (item.prefab == "orangestaff" or item.prefab == "yellowstaff") then
                            item:Remove()
                        end
                    end
                end
            end
        end)
    end

    -- 新生成：3 秒后箱子出现
    inst:DoTaskInTime(3.1, remove_staffs_from_chest)

    -- 读档：OnLoad 里立即调 dospawnchest，完事后清理
    local _old_OnLoad = inst.OnLoad
    inst.OnLoad = function(self, data, ...)
        if _old_OnLoad then _old_OnLoad(self, data, ...) end
        remove_staffs_from_chest()
    end
end)

AddPrefabPostInit("minotaur", function(inst)
    if not TheWorld.ismastersim then return end
    if inst and inst.components and inst.components.lootdropper then
        inst.components.lootdropper:AddChanceLoot("orangestaff", 1)
    end
end)

---------------------------------------------------------------------
-- 模块 m34_spawnervisible：显示生物群刷新点
-- 来源：m28_extinction.lua 第一部分
-- 功能：为所有群落(herd)和刷新点(objectspawner)添加可视化标记
---------------------------------------------------------------------

local ENABLED = GetModConfigData("spawner_visible")
if not ENABLED then return end

AddPrefabPostInitAny(function(inst)
    local is_spawnpoint = (inst:HasTag("herd") or (inst.components.objectspawner ~= nil and inst.spawnprefab ~= nil))
        and not inst:HasTag("telebase")
        and not inst:HasTag("fishschoolspawnblocker")
        and inst.prefab ~= "domesticplantherd"

    if not is_spawnpoint then return end

    if not inst.AnimState then
        inst.entity:AddAnimState()
    end
    if not inst.Network then
        inst.entity:AddNetwork()
    end

    inst.AnimState:SetBank("boatrace_checkpoint_indicator")
    inst.AnimState:SetBuild("boatrace_checkpoint_indicator")
    inst.AnimState:PlayAnimation("idle_closed")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(4)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetHaunted(true)

    if inst:HasTag("NOCLICK") then
        inst:RemoveTag("NOCLICK")
    end

    if TheWorld.ismastersim then
        inst:AddComponent("inspectable")
        local description = nil
        if inst:HasTag("herd") then
            if inst.components.periodicspawner ~= nil and inst.components.periodicspawner.prefab ~= nil then
                description = string.format("会刷新%s的群落点", inst.components.periodicspawner.prefab)
            elseif inst.components.herd ~= nil and inst.components.herd.membertag ~= nil then
                description = string.format("有%s标签的群落点", inst.components.herd.membertag)
            elseif inst.fishprefab ~= nil then
                description = string.format("鱼群%s的群落点", inst.fishprefab)
            end
        elseif inst.components.objectspawner ~= nil and inst.spawnprefab ~= nil then
            description = string.format("%s的刷新点", inst.spawnprefab)
        end
        if description ~= nil then
            inst.components.inspectable:SetDescription(description)
        end
    end
end)

---------------------------------------------------------------------
-- 模块：试金石/告密的心优化（m21_revive）
-- 参考：3459779337 原版内容修改 — set49
-- 试金石：无限作祟复活（掉血量上限，不破碎不落雷）
-- 告密的心：可作祟复活（一次性）
---------------------------------------------------------------------

local ENABLED = GetModConfigData("revive_enhance")
if not ENABLED then return end

---------------------------------------------------------------------
-- 共用作祟复活逻辑
---------------------------------------------------------------------
local function OnHaunt(inst, haunter)
    -- 防止重复触发（_task 表示正在复活中）
    if inst._task ~= nil then return end
    if haunter == nil or not haunter:IsValid() then return end
    if haunter.components.health == nil then return end

    inst._task = true -- 锁定

    -- 扣除血量上限（同绚丽之门效果：25%）
    haunter.components.health:DeltaPenalty(TUNING.PORTAL_HEALTH_PENALTY)
    -- 触发复活
    haunter:PushEvent("respawnfromghost", { source = inst })

    if inst.remove_by_haunt then
        inst:DoTaskInTime(0, function()
            if inst:IsValid() then inst:Remove() end
        end)
    end

    return true
end

---------------------------------------------------------------------
-- 动画结束回调：解锁试金石
---------------------------------------------------------------------
local function OnAnimOver(inst)
    inst:DoTaskInTime(0, function()
        if inst:IsValid() and inst.components.hauntable ~= nil then
            inst:RemoveTag("resurrector")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
            inst.components.hauntable:SetOnHauntFn(OnHaunt)
        end
        inst._task = nil
    end)
end

---------------------------------------------------------------------
-- 试金石
---------------------------------------------------------------------
AddPrefabPostInit("resurrectionstone", function(inst)
    -- 1) 移除原版自动复活（从事件表找到并移除）
    if inst.event_listeners ~= nil
        and inst.event_listeners["activateresurrection"] ~= nil
        and inst.event_listeners["activateresurrection"][inst] ~= nil then
        for _, fn in ipairs(inst.event_listeners["activateresurrection"][inst]) do
            inst:RemoveEventCallback("activateresurrection", fn)
        end
    end

    if not TheWorld.ismastersim then return end

    -- 2) 移除冷却限制（无限使用）
    if inst.components.cooldown ~= nil then
        inst:RemoveComponent("cooldown")
    end

    -- 3) 替换作祟行为
    if inst.components.hauntable ~= nil then
        inst.components.hauntable:SetOnHauntFn(OnHaunt)
    end

    -- 4) 动画结束复位
    inst:ListenForEvent("animover", OnAnimOver)
end)

---------------------------------------------------------------------
-- 告密的心
---------------------------------------------------------------------
AddPrefabPostInit("reviver", function(inst)
    if not TheWorld.ismastersim then return end

    inst:RemoveComponent("hauntable")
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)
    inst.remove_by_haunt = true  -- 一次性
end)

---------------------------------------------------------------------
-- 模块：小猪背包动态减速（m13_piggyback）
-- 参考：2927761874 原版改动 — piggyback.lua
-- 原理：清空固定减速 → 监听物品变化 → 按物品数量线性减速
---------------------------------------------------------------------

local SLOW_PERCENT = (GetModConfigData("piggyback_speed_per_item") or false) and 1 or 0
local SLOW_PER_ITEM = SLOW_PERCENT / 100

local function RedoSpeed(inst)
    if inst.components.container == nil then return end

    local count = 0
    for i = 1, #inst.components.container.slots do
        if inst.components.container.slots[i] ~= nil then
            count = count + 1
        end
    end

    if inst.components.equippable ~= nil then
        inst.components.equippable.walkspeedmult = 1 - (count * SLOW_PER_ITEM)
    end
end

AddPrefabPostInit("piggyback", function(inst)
    if not TheWorld.ismastersim then return end

    -- 清空原版固定减速，改为动态计算
    inst.components.equippable.walkspeedmult = 1

    -- 物品增减时重新计算速度
    inst:ListenForEvent("itemget", RedoSpeed)
    inst:ListenForEvent("itemlose", RedoSpeed)
end)

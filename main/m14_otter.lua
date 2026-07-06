---------------------------------------------------------------------
-- 模块：水獭不偷玩家（m14_otter）
-- 参考：3459779337 原版内容修改 — set6
-- 原理：让水獭的偷窃冷却始终"未结束"，
--       从而阻止翻箱子和偷玩家身上，
--       但不影响地上食物捡取/进食行为。
---------------------------------------------------------------------

local ENABLED = GetModConfigData("otter_no_steal")
if not ENABLED then return end

AddPrefabPostInit("otter", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.timer == nil then return end

    -- 让偷窃冷却始终"存在" → 水獭大脑不会发起偷窃动作
    local old_TimerExists = inst.components.timer.TimerExists
    inst.components.timer.TimerExists = function(self, name, ...)
        if name == "steallootcooldown" then
            return true
        end
        return old_TimerExists(self, name, ...)
    end
end)

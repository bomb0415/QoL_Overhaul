---------------------------------------------------------------------
-- 模块：马蹄铁幸运值（m11_horseshoe）
-- 参考：3679022286 更好的马蹄铁
---------------------------------------------------------------------

local MULT = GetModConfigData("luck_mult")
if MULT <= 1 then return end

TUNING.HORSESHOE_LUCK = TUNING.HORSESHOE_LUCK * MULT
TUNING.HORSESHOE_SETBONUS_LUCK = TUNING.HORSESHOE_SETBONUS_LUCK * MULT
-- 马年活动倍率（原版3x，也按比例放大的话会太高，直接保留原逻辑）
-- TUNING.HORSESHOE_EVENT_LUCK_MULTIPLIER 不变

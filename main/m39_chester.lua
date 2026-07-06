---------------------------------------------------------------------
-- 模块 m39_chester：小切哈奇无敌
-- 来源：m30_daily.lua
-- 功能：小切(chester)和哈奇(hutch)不会死亡
---------------------------------------------------------------------

if not GetModConfigData("chester_hutch") then return end

TUNING.CHESTER_HEALTH_REGEN_PERIOD = 0.1
TUNING.HUTCH_HEALTH_REGEN_PERIOD = 0.1
AddPrefabPostInit("chester", function(inst)
    if inst.components.health then
        inst.components.health:SetAbsorptionAmount(1)
    end
end)
AddPrefabPostInit("hutch", function(inst)
    if inst.components.health then
        inst.components.health:SetAbsorptionAmount(1)
    end
end)

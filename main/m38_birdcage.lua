---------------------------------------------------------------------
-- 模块 m38_birdcage：笼中鸟免喂不睡觉
-- 来源：m30_daily.lua
-- 功能：笼中鸟不需要喂食，不会睡觉，始终可用
---------------------------------------------------------------------

if not GetModConfigData("cage_bird") then return end

TUNING.PERISH_CAGE_MULT = -5
if TheNet:GetIsServer() then
    AddPrefabPostInit("birdcage", function(inst)
        if inst.components.trader then
            inst.components.trader:SetAbleToAcceptTest(function(inst, item, giver)
                if inst.components.health ~= nil and inst.components.health:IsDead() then
                    return false, "DEAD"
                elseif inst:HasTag("busy") then
                    return false, "BUSY"
                end
                return true
            end)
        end
    end)
end

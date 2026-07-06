---------------------------------------------------------------------
-- 模块 m37_heatrock：暖石无限耐久
-- 来源：m30_daily.lua
-- 功能：暖石不会耗尽，始终满耐久
---------------------------------------------------------------------

if not GetModConfigData("nuanshi") then return end

AddPrefabPostInit("heatrock", function(inst)
    inst:AddTag("hide_percentage")
    if inst.components.fueled then
        inst.components.fueled:SetPercent(1)
        inst.components.fueled.SetPercent = function(self) end
    end
end)

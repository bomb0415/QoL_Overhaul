---------------------------------------------------------------------
-- 模块 m35_rockfruit：石果不过熟
-- 来源：m30_daily.lua
-- 功能：石果停留在第3阶段，永不腐烂
---------------------------------------------------------------------

if GetModConfigData("plant_shiguo") then
    AddComponentPostInit("growable", function(self)
        local old_GetNextStage = self.GetNextStage
        function self:GetNextStage()
            local stage = self.stage + 1
            if stage > 3 and self.inst.prefab == "rock_avocado_bush" then
                stage = 3
                return stage
            end
            return old_GetNextStage(self)
        end
    end)
end

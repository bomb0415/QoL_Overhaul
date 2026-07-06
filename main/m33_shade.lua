---------------------------------------------------------------------
-- 模块 m33_shade：水中木荫蔽范围 + 冠下免疫沙尘暴
---------------------------------------------------------------------

-- 水中木荫蔽范围（原版22，默认拉满到44）
TUNING.SHADE_CANOPY_RANGE_SMALL = GetModConfigData("shade_canopy_range") or 44

-- 冠下沙尘暴免疫：canopytrees > 0 时强制 stormlevel = 0
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    local sw = inst.components.stormwatcher
    if sw == nil then return end

    local _UpdateStormLevel = sw.UpdateStormLevel
    function sw:UpdateStormLevel()
        _UpdateStormLevel(self)
        if inst.canopytrees and inst.canopytrees > 0 then
            self.stormlevel = 0
            if inst.components.sandstormwatcher then
                inst.components.sandstormwatcher:UpdateSandstormLevel()
            end
        end
    end

    -- canopy 状态变化时立刻重算，不用等下一轮 stormwatcher tick
    inst:ListenForEvent("onchangecanopyzone", function()
        sw:UpdateStormLevel()
    end)
end)

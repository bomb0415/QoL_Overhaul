---------------------------------------------------------------------
-- 模块：提灯 / 矿工帽（头灯）光照范围调节
---------------------------------------------------------------------

local LIGHT_RANGE_MULT = GetModConfigData("light_range_mult")

if LIGHT_RANGE_MULT == 1.0 then
    return
end

---------------------------------------------------------------------
-- 矿工帽 — minerhatlight 只 PostInit 设一次半径
---------------------------------------------------------------------
AddPrefabPostInit("minerhatlight", function(inst)
    if inst.Light ~= nil then
        local r = inst.Light:GetRadius()
        if r ~= nil and r > 0 then
            inst.Light:SetRadius(r * LIGHT_RANGE_MULT)
        end
    end
end)

---------------------------------------------------------------------
-- 提灯 — prefab 名是 "lantern"（不是 "mininglantern"）
-- 原版 fuelupdate 每帧 C++ Light:SetRadius(Lerp(3,5,fuel%))
-- 直接 SetUpdateFn 替换整个更新函数，半径乘倍率
---------------------------------------------------------------------
AddPrefabPostInit("lantern", function(inst)
    if inst.components.fueled == nil then return end

    inst.components.fueled:SetUpdateFn(function(inst)
        if inst._light == nil then return end
        local pct = inst.components.fueled:GetPercent()
        inst._light.Light:SetIntensity(Lerp(0.4, 0.6, pct))
        inst._light.Light:SetRadius(Lerp(3, 5, pct) * LIGHT_RANGE_MULT)
        inst._light.Light:SetFalloff(0.9)
    end)
end)

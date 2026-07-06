---------------------------------------------------------------------
-- 模块：堆肥桶上限24个（m05_compostingbin）
-- 作者：落叶异世之力
-- 参考：原版改动 — compostingbin
---------------------------------------------------------------------

local ENABLED = GetModConfigData("compostingbin_capacity_24")
if not ENABLED then return end

AddPrefabPostInit("compostingbin", function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.compostingbin == nil then return end

    inst.components.compostingbin.max_materials = 24

    -- 按容量比例缩放速度阈值，避免24格永远FAST
    local DURATION_MULTIPLIER = { FAST = 0.7, MEDIUM = 0.85, SLOW = 1.0 }
    inst.components.compostingbin.calcdurationmultfn = function(inst)
        local max = inst.components.compostingbin.max_materials
        local num = inst.components.compostingbin:GetMaterialTotal()
        return (num >= max     and DURATION_MULTIPLIER.FAST)
            or (num >= max*2/3 and DURATION_MULTIPLIER.MEDIUM)
            or DURATION_MULTIPLIER.SLOW
    end
end)

---------------------------------------------------------------------
-- 模块：龙蝇一次掉落3个皮（m10_dragonfly）
-- 作者：落叶异世之力
---------------------------------------------------------------------

local ENABLED = GetModConfigData("dragonfly_3_scales")
if not ENABLED then return end

AddPrefabPostInit("dragonfly", function(inst)
    if not TheWorld.ismastersim then return end

    -- 1) 移除眩晕时高伤害掉皮机制
    inst.components.damagetracker.damage_threshold_fn = nil

    -- 2) 替换掉落表：3个龙鳞 + 其他原版掉落
    GLOBAL.SetSharedLootTable("dragonfly_qol", {
        {'dragon_scales',             1.00},
        {'dragon_scales',             1.00},
        {'dragon_scales',             1.00},
        {'dragonflyfurnace_blueprint',1.00},
        {'chesspiece_dragonfly_sketch', 1.00},
        {'lavae_egg',                 0.33},
        {'meat', 1.00}, {'meat', 1.00}, {'meat', 1.00},
        {'meat', 1.00}, {'meat', 1.00}, {'meat', 1.00},
        {'goldnugget', 1.00}, {'goldnugget', 1.00},
        {'goldnugget', 1.00}, {'goldnugget', 1.00},
        {'goldnugget', 0.50}, {'goldnugget', 0.50},
        {'goldnugget', 0.50}, {'goldnugget', 0.50},
        {'redgem', 1.00}, {'bluegem', 1.00}, {'purplegem', 1.00},
        {'orangegem', 1.00}, {'yellowgem', 1.00}, {'greengem', 1.00},
        {'redgem', 1.00}, {'bluegem', 1.00}, {'purplegem', 0.50},
        {'orangegem', 0.50}, {'yellowgem', 0.50}, {'greengem', 0.50},
    })

    inst.components.lootdropper:SetChanceLootTable("dragonfly_qol")
end)

---------------------------------------------------------------------
-- 模块：小偷背包倍率调节（m07_krampus）
-- 作者：落叶异世之力
-- 参考：Customizable Krampus Sack
-- 原理：替换 krampus 的掉落表，背包概率可配置
---------------------------------------------------------------------

local CHANCE = GetModConfigData("krampus_sack_chance") / 100
if CHANCE <= 0 then return end

local SetSharedLootTable = GLOBAL.SetSharedLootTable

AddPrefabPostInit("krampus", function(inst)
    -- 替换共用掉落表（用 unique 表名避免干扰其他mod）
    SetSharedLootTable("krampii_qol", {
        { "monstermeat",  1.0 },
        { "charcoal",     1.0 },
        { "charcoal",     1.0 },
        { "krampus_sack", CHANCE },
    })

    if inst.components.lootdropper == nil then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:SetChanceLootTable("krampii_qol")
end)

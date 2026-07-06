---------------------------------------------------------------------
-- 模块：黄金工具去除耐久（m03_tools）
-- 作者：落叶异世之力
-- 原理：Hook SetUses 阻止使用次数下降 + attackwear=0 阻止武器磨损
---------------------------------------------------------------------

local ENABLED = GetModConfigData("golden_tools_no_durability")
if not ENABLED then return end

---------------------------------------------------------------------
-- 锁定有限使用次数，阻止下降
---------------------------------------------------------------------
local function MakeInfinite(inst)
    inst:AddTag("hide_percentage")  -- 隐藏耐久条

    if inst.components.finiteuses ~= nil then
        local old = inst.components.finiteuses.SetUses
        inst.components.finiteuses.SetUses = function(self, num)
            return old(self, math.max(num, self.current))
        end
    end

    if inst.components.weapon ~= nil then
        inst.components.weapon.attackwear = 0
    end
end

---------------------------------------------------------------------
-- 注册黄金工具
---------------------------------------------------------------------
for _, name in ipairs({
    "goldenaxe", "goldenpickaxe", "goldenshovel",
    "golden_farm_hoe", "goldenpitchfork",
}) do
    AddPrefabPostInit(name, MakeInfinite)
end

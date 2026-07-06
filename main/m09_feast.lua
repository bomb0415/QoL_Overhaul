---------------------------------------------------------------------
-- 模块：冬季盛宴击杀不掉落（m09_feast）
-- 作者：落叶异世之力
-- 参考：原版内容修改
-- 原理：掉落时伪装冬季盛宴未开启，节日物品就不加入掉落表了
---------------------------------------------------------------------

local ENABLED = GetModConfigData("disable_feast_loot")
if not ENABLED then return end

local _feast_nest_depth = 0  -- 调用深度计数器，防嵌套掉落踩踏

-- 1) 拦截 IsSpecialEventActive：掉落期间伪装冬季盛宴关闭
local _old_IsSpecialEventActive = GLOBAL.IsSpecialEventActive
GLOBAL.IsSpecialEventActive = function(event, ...)
    if _feast_nest_depth > 0 and event == SPECIAL_EVENTS.WINTERS_FEAST then
        return false
    end
    return _old_IsSpecialEventActive(event, ...)
end

-- 2) Hook lootdropper.DropLoot：包裹一个旗帜
AddComponentPostInit("lootdropper", function(self)
    local _old_DropLoot = self.DropLoot
    self.DropLoot = function(self, ...)
        _feast_nest_depth = _feast_nest_depth + 1
        local result = _old_DropLoot(self, ...)
        _feast_nest_depth = _feast_nest_depth - 1
        return result
    end
end)

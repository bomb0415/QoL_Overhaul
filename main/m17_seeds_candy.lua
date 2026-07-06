---------------------------------------------------------------------
-- 模块：种子袋 / 腐烂袋 优化（m17_seeds_candy）
-- 参考：3454347475 Smallchanges — seedpouch.lua + candybag.lua
---------------------------------------------------------------------

local ENABLED = GetModConfigData("bag_enhance")
if not ENABLED then return end

---------------------------------------------------------------------
-- 改名：糖果袋 → 腐烂袋（在游戏初始化后覆盖，避免被语言文件冲掉）
---------------------------------------------------------------------
AddGamePostInit(function()
    GLOBAL.STRINGS.NAMES.CANDYBAG = "腐烂袋"
    GLOBAL.STRINGS.RECIPE_DESC.CANDYBAG = "存放献祭给伟大暗影的食材"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.CANDYBAG = "腐烂的东西就该放在这里。"
end)

---------------------------------------------------------------------
-- 种子袋：永久保鲜种子
---------------------------------------------------------------------
AddPrefabPostInit("seedpouch", function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.preserver == nil then
        inst:AddComponent("preserver")
    end
    inst.components.preserver:SetPerishRateMultiplier(0)
    inst.components.inventoryitem.cangoincontainer = true
end)

---------------------------------------------------------------------
-- 腐烂袋：常驻制作 + 限制 + 20倍腐烂速度
---------------------------------------------------------------------

-- 改配方：常驻可做（移除万圣节限制）
AddRecipePostInit("candybag", function(recipe)
    recipe.level = TECH.SCIENCE_ONE
    recipe.hint_msg = nil
    recipe.nounlock = nil
end)

-- 改容器限制
local containers = require("containers")
containers.params.candybag.itemtestfn = function(container, item, slot)
    -- 万圣节物品和 trinket 照常接受
    if item:HasAnyTag("halloweencandy", "halloween_ornament")
        or string.sub(item.prefab, 1, 8) == "trinket_" then
        return true
    end
    if item:HasTag("smallcreature") then return false end
    if item:HasTag("preparedfood") or item:HasTag("weapon") or item:HasTag("tool") then
        return false
    end
    -- 有新鲜度的（肉/菜/果/鱼/种子等一切可腐烂物品）
    if item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled") then
        return true
    end
    -- 腐烂物本身（spoiled_food、rot 等）也要能放进去
    if string.find(item.prefab, "spoiled") or string.find(item.prefab, "rot") then
        return true
    end
    return false
end

-- 20倍腐烂速度 + 可放容器
AddPrefabPostInit("candybag", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(20)
    inst.components.inventoryitem.cangoincontainer = true
end)

---------------------------------------------------------------------
-- 腐烂袋 + Perish 处理：
-- 原版 perishable.lua 已正确处理：物品腐烂时保留堆叠数量，
-- 并调用 holder:GiveItem(goop, slot) 放回容器。
-- 我们只需确保 itemtestfn 接受 spoiled_food 即可，无需额外 Hook。
---------------------------------------------------------------------

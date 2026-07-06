GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

---------------------------------------------------------------------
-- 世界生成：地形优化 + 彩蛋
-- 来源：异世三叶草/yssy/modworldgenmain.lua + m22_terrain
---------------------------------------------------------------------

-- ============================
-- 原版地形优化
-- ============================
if GetModConfigData("better_biomes") then
    local Layouts = require("map/layouts").Layouts
    local StaticLayout = require("map/static_layout")

    -- 彩蛋地形
    Layouts["Chilled Base"] = StaticLayout.Get("map/static_layouts/trap_winter")
    Layouts["Chilled Decid Base"] = StaticLayout.Get("map/static_layouts/trap_winter_deciduous")
    Layouts["Hot Base"] = StaticLayout.Get("map/static_layouts/trap_summer")
    Layouts["Dev Graveyard"] = StaticLayout.Get("map/static_layouts/dev_graveyard")
    Layouts["Sleeping Spider"] = StaticLayout.Get("map/static_layouts/trap_sleepingspider")
    Layouts["Rotted Base"] = StaticLayout.Get("map/static_layouts/trap_spoilfood")
    Layouts["Beefalo Farm"] = StaticLayout.Get("map/static_layouts/beefalo_farm")
    Layouts["Ice Hounds"] = StaticLayout.Get("map/static_layouts/trap_icestaff")
    Layouts["Fire Hounds"] = StaticLayout.Get("map/static_layouts/trap_firestaff")
    Layouts["leif_forest"] = StaticLayout.Get("map/static_layouts/leif_forest")
    Layouts["spider_forest"] = StaticLayout.Get("map/static_layouts/spider_forest")
    Layouts["pigguard_berries"] = StaticLayout.Get("map/static_layouts/pigguard_berries")
    Layouts["pigguard_berries_easy"] = StaticLayout.Get("map/static_layouts/pigguard_berries_easy")
    Layouts["wasphive_grass_easy"] = StaticLayout.Get("map/static_layouts/wasphive_grass_easy")
    Layouts["hound_rocks"] = StaticLayout.Get("map/static_layouts/hound_rocks")
    Layouts["tenticle_reeds"] = StaticLayout.Get("map/static_layouts/tenticle_reeds")
    Layouts["tallbird_rocks"] = StaticLayout.Get("map/static_layouts/tallbird_rocks")
    Layouts["pigguard_grass"] = StaticLayout.Get("map/static_layouts/pigguard_grass")
    Layouts["pigguard_grass_easy"] = StaticLayout.Get("map/static_layouts/pigguard_grass_easy")
    Layouts["mactusk_village"] = StaticLayout.Get("map/static_layouts/mactusk_village")

    -- 读取配置（开关式）
    local _REEDS = GetModConfigData("easter_reeds") and 1 or 0
    local _DEVG = GetModConfigData("easter_graveyard") and 1 or 0
    local _TALLB = GetModConfigData("easter_tallbird") and 1 or 0
    local _PIGS = GetModConfigData("easter_pigguard") and 1 or 0
    local _LEIF = GetModConfigData("easter_leif") and 1 or 0
    local _SPIDER = GetModConfigData("easter_spider") and 1 or 0
    local _CANE = GetModConfigData("cane_boon") or 0

    -- 猪人守卫随机4种布局
    local pigtypes = {"pigguard_berries", "pigguard_berries_easy", "pigguard_grass", "pigguard_grass_easy"}
    math.randomseed(os.time())

    -- 定义任务区域
    local task_forest_any = {"Make a pick", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king",
        "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!",
        "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}
    local task_forest_swamp = {"Squeltch", "Lots-o-Spiders", "Lots-o-Tentacles", "Merms ahoy"}
    local task_forest_forest = {"The Deep Forest", "Befriend the pigs", "Kill the spiders", "Forest hunters"}
    local task_forest_savannah = {"Great Plains", "Greater Plains"}
    local task_forest_rocky = {"Mole Colony Rocks", "The hunters", "Dig that rock"}
    local task_forest_grasslands = {"Waspy Beeeees!", "For a nice walk", "Frogs and bugs", "Magic meadow",
        "Make a Beehat", "Killer bees!", "Wasps and Frogs and bugs"}

    -- 添加彩蛋
    local function AddSetPiece(name, count, tasks)
        if count <= 0 then return end
        AddLevelPreInitAny(function(level)
            if level.location ~= "forest" then return end
            if not level.set_pieces then level.set_pieces = {} end
            level.set_pieces[name] = { count = count, tasks = tasks }
        end)
    end

    if _DEVG > 0 then AddSetPiece("Dev Graveyard", _DEVG, task_forest_any) end
    if _TALLB > 0 then AddSetPiece("tallbird_rocks", _TALLB, task_forest_rocky) end
    if _REEDS > 0 then AddSetPiece("tenticle_reeds", _REEDS, task_forest_swamp) end
    if _LEIF > 0 then AddSetPiece("leif_forest", _LEIF, task_forest_any) end
    if _SPIDER > 0 then AddSetPiece("spider_forest", _SPIDER, task_forest_forest) end
    if _PIGS > 0 then
        for i = 1, _PIGS do
            local t = pigtypes[math.random(1, 4)]
            AddSetPiece(t, 1, task_forest_grasslands)
        end
    end

    -- 手杖前辈
    if _CANE > 0 then
        Layouts["CaneBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
            areas = {
                item_area = function() return {"cane"} end,
                resource_area = function() return nil end,
            },
        })
        AddSetPiece("CaneBoon", _CANE, task_forest_any)
    end

    -- 原版地形优化（移除特定群系+添加新群系）
    local forest_tasks = {"The hunters", "Killer bees!"}
    local forest_cannottasks = {"Mole Colony Deciduous", "Make a Beehat"}

    local function RemoveElementsFromA(A, B, C)
        local setBC = {}
        for _, v in ipairs(B or {}) do setBC[v] = true end
        for _, v in ipairs(C or {}) do setBC[v] = true end
        local result = {}
        for _, v in ipairs(A) do
            if not setBC[v] then table.insert(result, v) end
        end
        return result
    end

    AddLevelPreInitAny(function(level)
        if level.location ~= "forest" then return end
        for _, task in ipairs(forest_tasks) do
            table.insert(level.tasks, task)
        end
        level.numoptionaltasks = math.max(level.numoptionaltasks - #forest_tasks, 0)
        level.optionaltasks = RemoveElementsFromA(level.optionaltasks, forest_tasks, forest_cannottasks)
    end)
end

-- ============================
-- 关闭地形边缘复杂化（原m22功能）
-- ============================
if GetModConfigData("terrain_optimize") then
    AddGlobalClassPostConstruct("map/storygen", "Story", function(self, id, tasks, terrain, gen_params, level)
        if level and level.location ~= "forest" then return end
        self.AddCoveNodes = function(self, ...) end
    end)
end

GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

---------------------------------------------------------------------
-- 调试输出函数
---------------------------------------------------------------------
local DEBUG_ENABLED = GetModConfigData("qol_debug")
local function qol_log(mod, msg)
    if DEBUG_ENABLED then
        print("[QoL][" .. mod .. "] " .. msg)
    end
end

---------------------------------------------------------------------
-- 注册预制体
---------------------------------------------------------------------
PrefabFiles = {
    -- 割肉小刀
    "boningknife",
    -- 收割镰刀
    "um_scythe",
    -- 流浪商人图标
    "wanderingtrader_mapicon",
    -- 宝石袋
    "gem_pack",
    -- 雪球机增强（替换原版）
    "firesuppressor",
}

---------------------------------------------------------------------
-- 注册资源
---------------------------------------------------------------------
Assets = {
    -- 衣柜
    Asset("ATLAS", "images/dragonflycontainerborder.xml"),
    Asset("IMAGE", "images/dragonflycontainerborder.tex"),

    -- 25格大箱子容器UI背景
    Asset("ANIM", "anim/ui_chest_5x5.zip"),

    -- 割肉小刀
    Asset("ANIM", "anim/boningknife.zip"),
    Asset("ANIM", "anim/goldboningknife.zip"),
    Asset("ATLAS", "images/inventoryimages/boningknife.xml"),
    Asset("IMAGE", "images/inventoryimages/boningknife.tex"),
    Asset("ATLAS", "images/inventoryimages/goldboningknife.xml"),
    Asset("IMAGE", "images/inventoryimages/goldboningknife.tex"),

    -- 收获镰刀
    Asset("ANIM", "anim/scythe.zip"),
    Asset("ANIM", "anim/swap_scythe.zip"),
    Asset("ANIM", "anim/goldenscythe.zip"),
    Asset("ANIM", "anim/swap_goldenscythe.zip"),
    Asset("ATLAS", "images/inventoryimages/scythe_inv.xml"),
    Asset("IMAGE", "images/inventoryimages/scythe_inv.tex"),

    -- 流浪商人图标
    Asset("IMAGE", "images/map_icons/wanderingtrader_icon.tex"),
    Asset("ATLAS", "images/map_icons/wanderingtrader_icon.xml"),

    -- 宝石袋
    Asset("ANIM", "anim/gem_pack.zip"),
    Asset("ANIM", "anim/ui_icepack_2x3.zip"),
    Asset("ATLAS", "images/inventoryimages/gem_pack.xml"),
    Asset("IMAGE", "images/inventoryimages/gem_pack.tex"),
    Asset("ATLAS", "images/inventoryimages/gem_pack_open.xml"),
    Asset("IMAGE", "images/inventoryimages/gem_pack_open.tex"),
    Asset("ATLAS", "images/inventoryimages/gem_pack_slot.xml"),
    Asset("IMAGE", "images/inventoryimages/gem_pack_slot.tex"),
}

-- 流浪商人小地图图标
AddMinimapAtlas("images/map_icons/wanderingtrader_icon.xml")

qol_log("modmain", "资源注册完成")

---------------------------------------------------------------------
-- 第一阶段：改参数即可
---------------------------------------------------------------------
modimport("main/m01_light.lua")
modimport("main/m02_ghost.lua")
modimport("main/m03_tools.lua")
modimport("main/m04_wardrobe.lua")
modimport("main/m05_compostingbin.lua")
modimport("main/m06_orangestaff.lua")
modimport("main/m07_krampus.lua")
modimport("main/m08_dockturf.lua")
modimport("main/m09_feast.lua")
modimport("main/m10_dragonfly.lua")
qol_log("modmain", "第一阶段加载完成")

---------------------------------------------------------------------
-- 第二阶段：写简单逻辑
---------------------------------------------------------------------
modimport("main/m11_horseshoe.lua")
modimport("main/m12_tent.lua")
modimport("main/m13_piggyback.lua")
modimport("main/m14_otter.lua")
modimport("main/m15_unwrap.lua")
modimport("main/m16_sinkhole.lua")
modimport("main/m17_seeds_candy.lua")
modimport("main/m18_boningknife.lua")
modimport("main/m19_scythe.lua")
qol_log("modmain", "第二阶段加载完成")

---------------------------------------------------------------------
-- 第三阶段：复杂系统
---------------------------------------------------------------------
modimport("main/m20_pillar.lua")
modimport("main/m21_revive.lua")
-- m22_terrain 世界生成在 modworldgenmain.lua 中
modimport("main/m24_trader.lua")
qol_log("modmain", "第三阶段加载完成")

---------------------------------------------------------------------
-- 第四阶段：新物品
---------------------------------------------------------------------
modimport("main/m25_gempack.lua")
qol_log("modmain", "第四阶段加载完成")

---------------------------------------------------------------------
-- 第五阶段：世界生态
---------------------------------------------------------------------
modimport("main/m28_extinction.lua")     -- 防灭绝重生
modimport("main/m34_spawnervisible.lua")  -- 显示刷新点
qol_log("modmain", "第五阶段加载完成")

---------------------------------------------------------------------
-- 第六阶段：种植与农业
---------------------------------------------------------------------
modimport("main/m35_rockfruit.lua")       -- 石果不过熟
modimport("main/m36_beehat.lua")          -- 养蜂帽不叮
qol_log("modmain", "第六阶段加载完成")

---------------------------------------------------------------------
-- 第七阶段：日常优化
---------------------------------------------------------------------
modimport("main/m37_heatrock.lua")        -- 暖石无限
modimport("main/m38_birdcage.lua")        -- 笼中鸟免喂
modimport("main/m39_chester.lua")         -- 小切哈奇无敌
modimport("main/m40_minotaur.lua")        -- 犀牛必爆法杖
modimport("main/m32_firesuppressor.lua")   -- 雪球机增强
modimport("main/m33_shade.lua")            -- 水中木荫蔽
qol_log("modmain", "第七阶段加载完成")

---------------------------------------------------------------------
-- 第八阶段：储存增强（需在 Container 初始化之后）
---------------------------------------------------------------------
modimport("main/m31_bigchest.lua")         -- 25格大箱子
modimport("main/m41_fridge_fresh.lua")     -- 冰箱返鲜
qol_log("modmain", "第八阶段加载完成")

qol_log("modmain", "所有模块加载完成！")

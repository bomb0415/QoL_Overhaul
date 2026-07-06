name = "谁说我非得遭这个罪 / Suffering Is Optional"
description = [[
世界生成(需新档)：地形优化、手杖前辈、6种彩蛋、水中木荫蔽

日常便利：光照范围、鬼魂速度、金工具无限、懒人法杖CD、暖石、笼中鸟、小切、猪包、种子袋、拆包裹、马蹄铁、石果、养蜂帽

建筑增强：衣柜25格、大箱子25格、冰箱、堆肥桶24、帐篷、雪球机、码头、填坑

新增物品：剔骨尖刀、收割镰刀、宝石袋

生物掉落：坎普斯背包、龙鳞x3、水獭、冬季盛宴

系统机制：防灭绝、显示刷新点、支柱、试金石、流浪商人、犀牛必掉法杖
]]

author = "落叶长街"
version = "1.0.0"
priority = 10
icon_atlas = "modicon.xml"
icon = "modicon.tex"
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
client_only_mod = false
all_clients_require_mod = true

local onoff = {
    {description = "关闭", data = false},
    {description = "开启", data = true},
}

configuration_options = {
    ----------------------------------------------------------------
    -- 世界生成（需新档）
    ----------------------------------------------------------------
    {name = "TSECTION_WORLDGEN", label = "世界生成（需新档）", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "terrain_optimize",
        label = "地形优化",
        hover = "关闭地形边缘复杂化（需新档）",
        options = onoff,
        default = true,
    },
    {
        name = "better_biomes",
        label = "原版地形调整",
        hover = "增加海象平原/杀人蜂平原群系，移除鼹鼠桦树林/繁花陨石区",
        options = onoff,
        default = false,
    },
    {
        name = "cane_boon",
        label = "手杖前辈数量",
        hover = "0=关闭，1~5=世界随机生成对应数量的手杖前辈遗骸",
        options = {
            {description = "关闭", data = 0},
            {description = "1个", data = 1},
            {description = "2个", data = 2},
            {description = "3个", data = 3},
            {description = "4个", data = 4},
            {description = "5个", data = 5},
        },
        default = 0,
        slider_data = {0, 5, 1},
    },
    {
        name = "easter_graveyard",
        label = "墓地彩蛋",
        hover = "增加墓地地形",
        options = onoff,
        default = false,
    },
    {
        name = "easter_reeds",
        label = "芦苇彩蛋",
        hover = "增加芦苇触手地形",
        options = onoff,
        default = false,
    },
    {
        name = "easter_tallbird",
        label = "高脚鸟矿区彩蛋",
        hover = "增加高脚鸟矿区地形",
        options = onoff,
        default = false,
    },
    {
        name = "easter_pigguard",
        label = "猪人守卫彩蛋",
        hover = "增加猪人守卫营地地形",
        options = onoff,
        default = false,
    },
    {
        name = "easter_leif",
        label = "活木彩蛋",
        hover = "增加活木森林地形",
        options = onoff,
        default = false,
    },
    {
        name = "easter_spider",
        label = "蜘蛛彩蛋",
        hover = "增加蜘蛛森林地形",
        options = onoff,
        default = false,
    },
    {
        name = "shade_canopy_range",
        label = "水中木荫蔽范围",
        hover = "原版22，调节荫蔽范围。冠下完全免疫沙尘暴",
        options = {
            {description = "22（原版）", data = 22},
            {description = "33（1.5倍）", data = 33},
            {description = "44（2倍）", data = 44},
            {description = "66（3倍）", data = 66},
        },
        default = 44,
        slider_data = {22, 66, 11},
    },

    ----------------------------------------------------------------
    -- 日常便利
    ----------------------------------------------------------------
    {name = "TSECTION_DAILY", label = "日常便利", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "light_range_mult",
        label = "光照范围倍率",
        hover = "提灯/矿工帽发光范围倍率",
        options = {
            {description = "原版(1.0倍)", data = 1.0},
            {description = "1.5倍", data = 1.5},
            {description = "2.0倍", data = 2.0},
            {description = "2.5倍", data = 2.5},
            {description = "3.0倍", data = 3.0},
        },
        default = 2.0,
        slider_data = {1, 3, 0.5},
    },
    {
        name = "ghost_speed",
        label = "鬼魂移动速度",
        hover = "原版默认6，0=关闭",
        options = {
            {description = "关闭(原版6)", data = 0},
            {description = "8", data = 8},
            {description = "10", data = 10},
            {description = "12", data = 12},
        },
        default = 10,
    },
    {
        name = "golden_tools_no_durability",
        label = "黄金工具无限耐久",
        hover = "金斧/金镐/金铲不消耗耐久",
        options = onoff,
        default = true,
    },
    {
        name = "orangestaff_cooldown",
        label = "懒人法杖CD模式",
        hover = "去除耐久消耗，改为5秒冷却",
        options = onoff,
        default = true,
    },
    {
        name = "nuanshi",
        label = "暖石无限耐久",
        hover = "暖石不会耗尽",
        options = onoff,
        default = false,
    },
    {
        name = "cage_bird",
        label = "笼中鸟无需喂食不会睡觉",
        hover = "笼中鸟不饿不睡",
        options = onoff,
        default = false,
    },
    {
        name = "chester_hutch",
        label = "小切哈奇无敌",
        hover = "小切和哈奇不会死亡",
        options = onoff,
        default = false,
    },
    {
        name = "piggyback_speed_per_item",
        label = "猪背包每件减速1%",
        hover = "开启后背包内每件物品减速1%，空包不减速",
        options = onoff,
        default = true,
    },
    {
        name = "bag_enhance",
        label = "种子袋/腐烂袋优化",
        hover = "种子袋永久保鲜，腐烂袋20倍腐烂(腐烂物留在袋内)",
        options = onoff,
        default = true,
    },
    {
        name = "unwrap_to_inventory",
        label = "拆包裹进物品栏",
        hover = "拆包裹物品先进背包，满了才掉地上",
        options = onoff,
        default = true,
    },
    {
        name = "luck_mult",
        label = "马蹄铁幸运倍率",
        hover = "原版1x = 0.05",
        options = {
            {description = "原版 (1x)", data = 1},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "5x", data = 5},
            {description = "10x", data = 10},
        },
        default = 2,
    },
    {
        name = "plant_shiguo",
        label = "石果不过熟",
        hover = "石果不会过熟腐烂",
        options = onoff,
        default = false,
    },
    {
        name = "bee_ding",
        label = "养蜂帽采蜜不被叮",
        hover = "戴养蜂帽采蜜安全不被蜜蜂攻击",
        options = onoff,
        default = false,
    },

    ----------------------------------------------------------------
    -- 建筑增强
    ----------------------------------------------------------------
    {name = "TSECTION_BUILD", label = "建筑增强", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "wardrobe_25_slots",
        label = "衣柜25格空间",
        hover = "衣柜变为25格储物容器",
        options = onoff,
        default = true,
    },
    {
        name = "big_chest_enabled",
        label = "25格大箱子/冰箱",
        hover = "铥矿箱/冰箱升级为25格（5x5）",
        options = onoff,
        default = false,
    },
    {
        name = "icebox_freeze",
        label = "冰箱返鲜/保鲜",
        hover = "0=永久保鲜 -1=缓慢返鲜 0.2=腐烂较慢 0.5=正常腐烂 2=腐烂更快",
        options = {
            {description = "永久保鲜 0", data = 0},
            {description = "缓慢返鲜 -1", data = -1},
            {description = "腐烂较慢 0.2", data = 0.2},
            {description = "正常腐烂 0.5", data = 0.5},
            {description = "腐烂更快 2", data = 2},
        },
        default = 0.5,
    },
    {
        name = "compostingbin_capacity_24",
        label = "堆肥桶容量24",
        hover = "堆肥桶材料上限改为24个",
        options = onoff,
        default = true,
    },
    {
        name = "tent_enhance",
        label = "帐篷/遮阳棚强化",
        hover = "无限耐久+微光+3倍回血+2倍饥饿+恢复血量上限+优化配方",
        options = onoff,
        default = true,
    },
    {
        name = "range_mult",
        label = "雪球机灭火范围",
        hover = "始终开启：无限燃料+自动浇水+无碰撞+不灭营火+阴燃保护",
        options = {
            {description = "约15格（原版）", data = 1.55},
            {description = "约30格（两倍）", data = 2.15},
            {description = "约45格（三倍）", data = 3.15},
        },
        default = 2.15,
    },
    {
        name = "turf_on_dock",
        label = "码头可铺设地皮",
        hover = "可在码头地板上铺设草皮",
        options = onoff,
        default = true,
    },
    {
        name = "fill_sinkhole",
        label = "蚁狮陷坑可填补",
        hover = "用15块石头填补蚁狮陷坑",
        options = onoff,
        default = true,
    },

    ----------------------------------------------------------------
    -- 新增物品
    ----------------------------------------------------------------
    {name = "TSECTION_ITEMS", label = "新增物品", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "boning_knife",
        label = "割肉小刀",
        hover = "添加剔骨尖刀，大肉切为小肉",
        options = onoff,
        default = true,
    },
    {
        name = "scythe_harvest",
        label = "收割镰刀",
        hover = "添加镰刀+黄金镰刀，范围采集作物",
        options = onoff,
        default = true,
    },
    {
        name = "gempack_enable",
        label = "宝石袋",
        hover = "添加宝石袋，8格仅存放宝石",
        options = onoff,
        default = true,
    },

    ----------------------------------------------------------------
    -- 生物与掉落
    ----------------------------------------------------------------
    {name = "TSECTION_CREATURE", label = "生物与掉落", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "krampus_sack_chance",
        label = "坎普斯背包掉率",
        hover = "原版基准约1%",
        options = {
            {description = "原版 (1%)",  data = 1},
            {description = "2%",  data = 2},
            {description = "3%",  data = 3},
            {description = "5%",  data = 5},
            {description = "10%", data = 10},
            {description = "15%", data = 15},
            {description = "20%", data = 20},
            {description = "50%", data = 50},
            {description = "100%", data = 100},
        },
        default = 10,
    },
    {
        name = "dragonfly_3_scales",
        label = "龙鳞掉落x3",
        hover = "龙蝇死亡掉落3个龙鳞，移除眩晕掉皮",
        options = onoff,
        default = true,
    },
    {
        name = "otter_no_steal",
        label = "水獭不偷玩家",
        hover = "水獭不偷身上/不翻箱子，只吃地上食物",
        options = onoff,
        default = true,
    },
    {
        name = "disable_feast_loot",
        label = "冬季盛宴不掉落",
        hover = "冬季盛宴击杀生物不掉落节日食物和饰品",
        options = onoff,
        default = true,
    },

    ----------------------------------------------------------------
    -- 系统机制
    ----------------------------------------------------------------
    {name = "TSECTION_SYSTEM", label = "系统机制", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "extinction_prevent",
        label = "防灭绝重生",
        hover = "关键生物低于保底数量自动重生（1-5天）",
        options = onoff,
        default = true,
    },
    {
        name = "extinction_min_count",
        label = "保底数量",
        hover = "生物少于这个数触发重生",
        options = {
            {description = "1个", data = 1},
            {description = "2个", data = 2},
            {description = "3个", data = 3},
            {description = "4个", data = 4},
            {description = "5个", data = 5},
        },
        default = 2,
        slider_data = {1, 5, 1},
    },
    {
        name = "extinction_respawn_time",
        label = "重生时间（天）",
        hover = "灭绝后多少天重生",
        options = {
            {description = "1天", data = 1},
            {description = "3天", data = 3},
            {description = "5天", data = 5},
            {description = "7天", data = 7},
            {description = "10天", data = 10},
        },
        default = 5,
    },
    {
        name = "spawner_visible",
        label = "显示刷新点",
        hover = "地图上显示生物群落和刷新点位置（可检查）",
        options = onoff,
        default = true,
    },
    {
        name = "pillar_protect",
        label = "支柱免疫地震+酸雨",
        hover = "修好支柱不受地震影响，保护范围免疫酸雨",
        options = onoff,
        default = true,
    },
    {
        name = "revive_enhance",
        label = "试金石/告密的心优化",
        hover = "试金石无限作祟复活（掉上限不破碎），告密的心可复活",
        options = onoff,
        default = true,
    },
    {
        name = "wandering_trader",
        label = "流浪商人优化",
        hover = "流浪商人固定位置+地图图标",
        options = onoff,
        default = true,
    },

    ----------------------------------------------------------------
    -- 调试
    ----------------------------------------------------------------
    {name = "TSECTION_DEBUG", label = "调试", section_start = true, options = {{description = "", data = ""}}, default = ""},
    {
        name = "qol_debug",
        label = "调试模式",
        hover = "开启后控制台输出各模块加载状态",
        options = onoff,
        default = false,
    },
}

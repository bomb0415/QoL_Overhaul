# 谁说我非得遭这个罪 / Suffering Is Optional

<img src="preview.png" width="320" alt="预览">

你再也不用被重复劳作和无意义的折磨绑架。
You don't have to suffer just because the game says so.

**所有功能均可独立开关。Every feature independently toggleable.**

---

本模组收集并整合了部分优秀但不再维护的 Mod，修复了一些遗留问题，也重写了一些功能。感谢所有前辈大佬的开源与代码分享，让后来者得以学习和延续。
This mod integrates several excellent but unmaintained mods, fixes legacy bugs, and rewrites features from scratch. Thanks to all pioneers who open-sourced their code, so that those who come after can learn and carry on.

---

## 项目结构 / Project Structure

```
QoL_Overhaul/
├── anim/           # 动画资源（9个）
├── images/         # 物品贴图、地图图标、UI边框
├── main/           # 功能模块（37个，全部独立开关）
│   ├── m01~m21/    # 基础功能模块
│   └── m24~m41/    # 扩展功能模块
├── scripts/        # 自定义组件 & prefab
│   ├── components/ # 6个自定义组件
│   └── prefabs/    # 5个自定义prefab
├── modinfo.lua     # Mod配置（7大分类，全部独立开关）
├── modmain.lua     # 主入口
└── modworldgenmain.lua  # 世界生成入口
```

| 分类 | 模块数 | 说明 |
|---|---|---|
| 世界生成 | 5 | 地形优化、彩蛋、水中木荫蔽 |
| 日常便利 | 13 | 光照、鬼魂、工具、暖石、鸟笼等 |
| 建筑增强 | 8 | 衣柜、大箱、冰箱、帐篷、雪球机 |
| 新增物品 | 3 | 剔骨尖刀、收割镰刀、宝石袋 |
| 生物掉落 | 4 | 坎普斯、龙蝇、水獭、冬季盛宴 |
| 系统机制 | 6 | 防灭绝、刷新点、支柱、复活等 |
| 世界生成入口 | 1 | 地形生成调节 |

## 一、世界生成（需新档）/ World Generation (new world)

- **地形优化 / Terrain Optimization** — 关闭地形边缘复杂化，减少锯齿海岸线
- **原版地形调整 / Biome Adjustment** — 强制海象平原+杀人蜂平原，移除鼹鼠桦树林和繁花陨石区
- **手杖前辈 / Cane Boon** — 世界随机位置生成步行手杖遗骸，0~5个可调
- **6种彩蛋 / 6 Easter Eggs** — 墓地、芦苇触手、高脚鸟矿区、猪人守卫营地、活木森林、蜘蛛森林
- **水中木荫蔽 / Waterlogged Canopy** — 可调范围(22~66)，冠下完全免疫沙尘暴

## 二、日常便利 / Daily Convenience

- **光照范围倍率 / Light Range** — 提灯和矿工帽发光范围 1x~3x 可调
- **鬼魂速度 / Ghost Speed** — 死亡后鬼魂移速可调(6/8/10/12)
- **黄金工具无限 / Golden Tools** — 金斧、金镐、金铲不消耗耐久
- **懒人法杖CD / Lazy Explorer CD** — 移除耐久，改为5秒冷却
- **暖石无限 / Thermal Stone** — 暖石不耗尽耐久
- **笼中鸟 / Birdcage** — 无需喂食，不睡觉，始终保持可交易
- **小切哈奇无敌 / Chester & Hutch** — 100%伤害减免
- **猪背包 / Piggyback** — 每件物品减速1%，空包不减速
- **种子袋/腐烂袋 / Seed & Rot Bag** — 种子永久保鲜，腐烂袋20倍腐烂
- **拆包裹进包 / Unwrap to Inventory** — 优先进入背包
- **马蹄铁 / Lucky Horseshoe** — 幸运倍率 1x~10x 可调
- **石果 / Stone Fruit** — 不过熟枯萎
- **养蜂帽 / Beekeeper Hat** — 采蜜不被蜜蜂攻击

## 三、建筑增强 / Building

- **衣柜25格 / Wardrobe 25 slots** — 工具武器专用收纳，更好的放置
- **大箱子+冰箱25格(5x5) / Chest & Fridge 25 slots**
- **冰箱返鲜 / Fridge perish** — 5档：永久保鲜/返鲜/慢腐烂/正常/快腐烂
- **堆肥桶24格 / Composting Bin 24**
- **帐篷/遮阳棚 / Tent & Siesta** — 无限耐久+微光+3倍回血+2倍饥饿（平衡性调整）+恢复血量上限
- **雪球机 / Flingomatic** — 可选灭火范围+无限燃料+自动浇水+无碰撞+不灭营火+阴燃保护
- **码头铺地皮 / Turf on Docks**
- **蚁狮陷坑可填 / Fill Sinkholes** — 15块石头填补

## 四、新增物品 / New Items

- **剔骨尖刀 / Boning Knife** — 大肉切小肉
- **收割镰刀 / Harvest Scythe** — 范围采集作物
- **宝石袋 / Gem Bag** — 8格专用宝石容器

## 五、生物与掉落 / Creatures & Drops

- **坎普斯背包掉率 1%~100% / Krampus Sack rate adjustable**
- **龙蝇掉3龙鳞 / Dragonfly 3 scales** — 取消眩晕伤害过载掉皮机制
- **水獭不偷玩家 / Otter no steal**
- **冬季盛宴不掉落 / No Feast loot**

## 六、系统机制 / System

- **防灭绝重生 / Extinction** — 关键生物低数量自动重生，保底数和间隔可调
- **显示刷新点 / Spawner Visible** — 高亮显示生物群落和刷新点
- **支柱免疫 / Pillar Protection** — 地震+酸雨免疫
- **试金石/告密的心 / Touch Stone & Heart** — 无限作祟复活+告密的心复活
- **流浪商人 / Wandering Trader** — 绚丽之门固定生成
- **犀牛必掉法杖 / Guardian drops Lazy Explorer** — 拒绝无意义回档

---

## 闲谈 / Notes

本模组借鉴了工坊中许多优秀Mod的思路与代码，经重构整合而成。因涉及的Mod过多，暂难逐一引用，在此向所有先行者致以诚挚感谢。后续版本会逐步补充引用列表。欢迎反馈bug和建议。

This release was rebuilt from ideas and code borrowed across many excellent Workshop mods. Too many to cite individually at this stage — heartfelt thanks to every creator who paved the way. Attribution will be added in future updates. Bug reports and suggestions welcome.

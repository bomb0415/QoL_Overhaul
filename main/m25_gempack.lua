---------------------------------------------------------------------
-- 模块 m25_gempack：宝石袋
-- 完全照搬参考Mod（3441532568）
---------------------------------------------------------------------

local ENABLED = GetModConfigData("gempack_enable")
if not ENABLED then return end

local containers = require("containers")

containers.params.gem_pack =
{
    widget =
    {
        slotpos = {},
        slotbg  = {},
        animbank  = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(320, -150, 0),
    },
    type = "chest",
}

local gem_pack_slot = { image = "gem_pack_slot.tex" , atlas = "images/inventoryimages/gem_pack_slot.xml"}

for y = 0, 3 do
    table.insert(containers.params.gem_pack.widget.slotpos, Vector3(-162     , -75 * y + 114, 0))
    table.insert(containers.params.gem_pack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))

    table.insert(containers.params.gem_pack.widget.slotbg, gem_pack_slot)
    table.insert(containers.params.gem_pack.widget.slotbg, gem_pack_slot)
end

function containers.params.gem_pack.itemtestfn(container, item, slot)
    if string.sub(item.prefab, -3, -1) == "gem" then
        return true
    end
	return false
end

AddMinimapAtlas("images/inventoryimages/gem_pack.xml")

AddRecipe2("gem_pack", {Ingredient("slurper_pelt", 6), Ingredient("thulecite_pieces",2), Ingredient("orangegem",1)},TECH.ANCIENT_FOUR,{nounlock=true, atlas="images/inventoryimages/gem_pack.xml", image= "gem_pack.tex"}, {"CHARACTER"})

STRINGS.NAMES.GEM_PACK = "宝石袋"
STRINGS.RECIPE_DESC.GEM_PACK = "存放各种宝石的便捷小袋。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GEM_PACK = "一个专门存放宝石的袋子。"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.GEM_PACK = "我会让里面装满红宝石！"
STRINGS.CHARACTERS.WENDY.DESCRIBE.GEM_PACK = "存的越多，失去时也就越痛苦。"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.GEM_PACK = "沃尔夫冈不认为它比土豆袋重！"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.GEM_PACK = "它创造了一个仅限宝石进入的空间囚禁漩涡。"
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.GEM_PACK = "在以前……这种装满了宝石的东西随便堆积在王座之下。"
STRINGS.CHARACTERS.WX78.DESCRIBE.GEM_PACK = "宝石额外储蓄模块"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.GEM_PACK = "让我这个乡下人产生了我是有钱人的错觉。"
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.GEM_PACK = "为真正勇士准备的藏宝袋！"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.GEM_PACK = "没有它，我们也可以一只手拿一个宝石。"
STRINGS.CHARACTERS.WINONA.DESCRIBE.GEM_PACK = "哈，像是资本家提着的钱袋子。"
STRINGS.CHARACTERS.WURT.DESCRIBE.GEM_PACK = "浮浪噗，摸着舒服。"
STRINGS.CHARACTERS.WARLY.DESCRIBE.GEM_PACK = "让我想起一句台词：“我当厨师的所有积蓄都放在这个袋子里了。”"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.GEM_PACK = "放心，它装不走小动物。"
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.GEM_PACK = "装闪闪的东西用的"

---------------------------------------------------------------------
-- 模块：割肉小刀（m18_boningknife）
-- 参考：3697052782 UMBeta-Overhaul — boningknife + ypjw_additions
---------------------------------------------------------------------

local ENABLED = GetModConfigData("boning_knife")
if not ENABLED then return end

---------------------------------------------------------------------
-- 配方
---------------------------------------------------------------------
AddRecipe2("boningknife",
    { Ingredient("twigs", 2), Ingredient("flint", 4) },
    TECH.SCIENCE_ONE,
    { atlas = "images/inventoryimages/boningknife.xml", image = "boningknife.tex" },
    { "TOOLS" }
)

AddRecipe2("goldboningknife",
    { Ingredient("twigs", 4), Ingredient("goldnugget", 4) },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/goldboningknife.xml", image = "goldboningknife.tex" },
    { "TOOLS" }
)

---------------------------------------------------------------------
-- 多语言名称
---------------------------------------------------------------------
STRINGS.NAMES.BONINGKNIFE = "剔骨尖刀"
STRINGS.RECIPE_DESC.BONINGKNIFE = "把大肉切割成小肉，物尽其用。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONINGKNIFE = "可以切肉的好工具。"
STRINGS.NAMES.GOLDBONINGKNIFE = "剔骨金刀"
STRINGS.RECIPE_DESC.GOLDBONINGKNIFE = "奢侈地把大肉切割成小肉。"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GOLDBONINGKNIFE = "金闪闪的切肉刀！"

---------------------------------------------------------------------
-- 可切割的食物映射
---------------------------------------------------------------------
local sliceable_foods = {
    meat            = { product = "smallmeat",        slicesize = 2 },
    cookedmeat      = { product = "cookedsmallmeat",  slicesize = 2 },
    meat_dried      = { product = "smallmeat_dried",  slicesize = 2 },
}

local function AddSliceable(inst)
    inst:AddTag("sliceable")
    if not TheWorld.ismastersim then return end
    inst:AddComponent("sliceable")
    local entry = sliceable_foods[inst.prefab]
    if entry then
        inst.components.sliceable:SetProduct(entry.product, entry.slicesize)
    end
end

for prefab_name, _ in pairs(sliceable_foods) do
    AddPrefabPostInit(prefab_name, AddSliceable)
end

---------------------------------------------------------------------
-- SLICE / SLICESTACK 动作定义
---------------------------------------------------------------------
AddAction("SLICE", "切割", function(act)
    local target = act.target
    if target == nil or not target:IsValid() then return false end
    if not target:HasTag("sliceable") then return false end
    if act.invobject == nil or not act.invobject:HasTag("slicer") then return false end
    if target.components ~= nil and target.components.sliceable ~= nil then
        target.components.sliceable:OnSlice(act.doer)
        act.doer.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")
        return true
    end
    return false
end)
ACTIONS.SLICE.priority = 2
ACTIONS.SLICE.mount_valid = true
STRINGS.ACTIONS.SLICE = "切割"

AddAction("SLICESTACK", "整组切割", function(act)
    local target = act.target
    if target == nil or not target:IsValid() then return false end
    if not target:HasTag("sliceable") then return false end
    if act.invobject == nil or not act.invobject:HasTag("professionalslicer") then return false end
    if target.components ~= nil and target.components.sliceable ~= nil then
        target.components.sliceable:OnSliceStack(act.doer)
        return true
    end
    return false
end)
ACTIONS.SLICESTACK.priority = 2
ACTIONS.SLICESTACK.mount_valid = true
STRINGS.ACTIONS.SLICESTACK = "整组切割"

---------------------------------------------------------------------
-- USEITEM 模式：拿起刀（不装备）→ 鼠标右键点肉
---------------------------------------------------------------------
AddComponentAction("USEITEM", "slicer", function(inst, doer, target, actions, right)
    if target == nil or not target:IsValid() then return end
    if not target:HasTag("sliceable") then return end
    local act = ACTIONS.SLICE
    if target.replica.stackable ~= nil and target.replica.stackable:IsStack()
        and doer.components.playercontroller ~= nil
        and doer.components.playercontroller:IsControlPressed(CONTROL_FORCE_STACK)
        and inst:HasTag("professionalslicer") then
        act = ACTIONS.SLICESTACK
    end
    table.insert(actions, act)
end)

---------------------------------------------------------------------
-- 状态图动画处理器
---------------------------------------------------------------------
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLICE, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLICE, "doshortaction"))
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLICESTACK, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLICESTACK, "doshortaction"))

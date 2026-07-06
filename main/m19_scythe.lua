---------------------------------------------------------------------
-- 模块：收割镰刀（m19_scythe）
-- 参考：3697052782 UMBeta-Overhaul — um_scythe + scythe_harvest
---------------------------------------------------------------------

local ENABLED = GetModConfigData("scythe_harvest")
if not ENABLED then return end

---------------------------------------------------------------------
-- 1. TUNING 配置
---------------------------------------------------------------------
TUNING.UM_SCYTHE = {
    USES = 75,
    HARVEST_RADIUS = 6,
    DAMAGE = 27.2,
    DAMAGE_RADIUS = 2,
    PLANT_DAMAGE_MULT = 1.5,
}

---------------------------------------------------------------------
-- 2. 注册自定义动作 UM_AREAPICK
---------------------------------------------------------------------
STRINGS.ACTIONS.UM_AREAPICK = "范围采集"

local UM_AREAPICK = AddAction("UM_AREAPICK", "范围采集", function(act)
    local equip = act.invobject or (act.doer ~= nil and act.doer.components.inventory ~= nil
        and act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil)
    if act.doer ~= nil and act.target ~= nil and equip ~= nil and equip.components.um_areapicker ~= nil then
        return equip.components.um_areapicker:Pick(act.doer, act.target)
    end
end)

UM_AREAPICK.priority = 2
UM_AREAPICK.canforce = true
UM_AREAPICK.rangecheckfn = ACTIONS.PICK.rangecheckfn
UM_AREAPICK.extra_arrive_dist = ACTIONS.PICK.extra_arrive_dist
UM_AREAPICK.mount_valid = true

---------------------------------------------------------------------
-- 3. 判断目标是否可范围采集
---------------------------------------------------------------------
local function IsHarvestableTarget(target)
    if target == nil or not target:IsValid() then return false end
    if target.prefab == "beebox" or target.prefab == "mega_beebox" then
        return false
    end
    -- 标签检查
    if (target:HasTag("plant") and target:HasTag("pickable"))
        or target:HasTag("readyforharvest")
        or target:HasTag("harvestable")
        or target:HasTag("takeshelfitem")
        or target:HasTag("dried") then
        return true
    end
    -- 组件检查（捕获无显式标签的植物）
    if target.components ~= nil then
        if target.components.pickable ~= nil and target.components.pickable:CanBePicked() then
            return true
        end
        if target.components.harvestable ~= nil and target.components.harvestable:CanBeHarvested() then
            return true
        end
        if target.components.crop ~= nil then
            return not target.components.crop:IsWithered() and target.components.crop:IsReadyForHarvest()
        end
    end
    return false
end

---------------------------------------------------------------------
-- 4. 注册 ComponentAction
---------------------------------------------------------------------
AddComponentAction("USEITEM", "um_areapicker", function(inst, doer, target, actions, right)
    if inst:HasTag("um_areapicker") and IsHarvestableTarget(target) then
        table.insert(actions, UM_AREAPICK)
    end
end)

AddComponentAction("EQUIPPED", "um_areapicker", function(inst, doer, target, actions, right)
    if inst:HasTag("um_areapicker") and IsHarvestableTarget(target) then
        table.insert(actions, UM_AREAPICK)
    end
end)

---------------------------------------------------------------------
-- 5. 状态图动作处理器
---------------------------------------------------------------------
AddStategraphActionHandler("wilson", ActionHandler(UM_AREAPICK, "dojostleaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(UM_AREAPICK, "dojostleaction"))

---------------------------------------------------------------------
-- 6. 空格键自动范围采集（PlayerController 钩子）
---------------------------------------------------------------------
AddComponentPostInit("playercontroller", function(self)
    local OLD_GetActionButtonAction = self.GetActionButtonAction

    function self:GetActionButtonAction(...)
        local buffer = not self:IsDoingOrWorking() and OLD_GetActionButtonAction(self, ...) or nil
        if buffer == nil then return nil end

        local target = buffer.target
        local tool = buffer.invobject

        if target ~= nil and IsHarvestableTarget(target) then
            if tool ~= nil and tool:HasTag("um_areapicker") and not tool:HasTag("areapicker") then
                buffer.action = UM_AREAPICK
            end
        end

        return buffer
    end
end)

---------------------------------------------------------------------
-- 7. 配方
---------------------------------------------------------------------
RegisterInventoryItemAtlas("images/inventoryimages/scythe_inv.xml", "scythe.tex")
RegisterInventoryItemAtlas("images/inventoryimages/scythe_inv.xml", "goldenscythe.tex")

AddRecipe2("um_scythe",
    { Ingredient("twigs", 2), Ingredient("flint", 2) },
    TECH.SCIENCE_ONE,
    { atlas = "images/inventoryimages/scythe_inv.xml", image = "scythe.tex" },
    { "TOOLS" }
)

AddRecipe2("um_goldenscythe",
    { Ingredient("twigs", 4), Ingredient("goldnugget", 2) },
    TECH.SCIENCE_TWO,
    { atlas = "images/inventoryimages/scythe_inv.xml", image = "goldenscythe.tex" },
    { "TOOLS" }
)

---------------------------------------------------------------------
-- 8. 名称描述
---------------------------------------------------------------------
STRINGS.NAMES.UM_SCYTHE = "镰刀"
STRINGS.RECIPE_DESC.UM_SCYTHE = "范围收割各种作物"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.UM_SCYTHE = "很有效率！"
STRINGS.NAMES.UM_GOLDENSCYTHE = "黄金镰刀"
STRINGS.RECIPE_DESC.UM_GOLDENSCYTHE = "像贵族一样收割"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.UM_GOLDENSCYTHE = "一分耕耘一分收获"

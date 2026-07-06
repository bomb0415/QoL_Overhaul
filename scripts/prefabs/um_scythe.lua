-- 镰刀和黄金镰刀预制件
-- 基于 workshop-2328604820 镰刀模组，使用 um_areapicker 组件替代 areapicker

local assets =
{
    Asset("ANIM", "anim/scythe.zip"),
    Asset("ANIM", "anim/swap_scythe.zip"),
}

local golden_assets =
{
    Asset("ANIM", "anim/goldenscythe.zip"),
    Asset("ANIM", "anim/swap_goldenscythe.zip"),
}

local function OnFinished(inst)
    if inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", {tool = inst})
    end
    inst:Remove()
end

local function CalDamage(inst, owner, target)
    local base = TUNING.UM_SCYTHE.DAMAGE
    return target ~= nil and target:HasTag("veggie") and base * TUNING.UM_SCYTHE.PLANT_DAMAGE_MULT or base
end

local function OnAttack(inst, owner, target)
    -- 无范围攻击，仅保留普通的单体伤害（由 CalDamage 计算）
end

local function OnEquip(inst, owner)
    if inst:HasTag("goldentool") then
        owner.AnimState:OverrideSymbol("swap_object", "swap_goldenscythe", "swap_goldenscythe")
        owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_scythe", "swap_scythe")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function common_fn(bank, build, tooltype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle")

    if tooltype then
        inst:AddTag(tooltype.."tool")
    end
    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("bramble_resistant")
    inst:AddTag("um_areapicker")

    MakeInventoryFloatable(inst, "med", 0.05, {0.75, 0.4, 0.75}, true, -11, {sym_build = build})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.SCYTHE)

    local finiteuses = inst:AddComponent("finiteuses")
    finiteuses:SetMaxUses(TUNING.UM_SCYTHE.USES)
    finiteuses:SetUses(TUNING.UM_SCYTHE.USES)
    finiteuses:SetOnFinished(OnFinished)

    local action = ACTIONS.UM_AREAPICK
    if inst:HasTag("goldentool") then
        finiteuses:SetConsumption(action, 1 / TUNING.GOLDENTOOLFACTOR)
        finiteuses:SetConsumption(ACTIONS.SCYTHE, 1 / TUNING.GOLDENTOOLFACTOR)
    else
        finiteuses:SetConsumption(action, 1)
        finiteuses:SetConsumption(ACTIONS.SCYTHE, 1)
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(CalDamage)
    inst.components.weapon:SetOnAttack(OnAttack)
    inst.components.weapon.attackwear = inst:HasTag("goldentool") and 2 / TUNING.GOLDENTOOLFACTOR or 2

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = bank
    inst.components.inventoryitem.atlasname = "images/inventoryimages/scythe_inv.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("um_areapicker")
    inst.components.um_areapicker:SetRadius(TUNING.UM_SCYTHE.HARVEST_RADIUS)

    MakeHauntableLaunch(inst)
    return inst
end

local function normal()
    return common_fn("scythe", "swap_scythe")
end

local function golden()
    return common_fn("goldenscythe", "swap_goldenscythe", "golden")
end

return  Prefab("um_scythe", normal, assets),
        Prefab("um_goldenscythe", golden, golden_assets)

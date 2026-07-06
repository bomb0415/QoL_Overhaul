-- 剔骨尖刀 / 剔骨金刀
-- 功能：将大肉切割成小肉

local assets = {
    Asset("ANIM", "anim/boningknife.zip"),
    Asset("ATLAS", "images/inventoryimages/boningknife.xml"),
    Asset("IMAGE", "images/inventoryimages/boningknife.tex"),
}

local goldassets = {
    Asset("ANIM", "anim/goldboningknife.zip"),
    Asset("ATLAS", "images/inventoryimages/goldboningknife.xml"),
    Asset("IMAGE", "images/inventoryimages/goldboningknife.tex"),
}

-- 剔骨尖刀（有耐久）
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("boningknife")
    inst.AnimState:SetBuild("boningknife")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetScale(1.3, 1.3, 1.3)

    inst:AddTag("sharp")
    inst:AddTag("tool")
    inst:AddTag("slicer")

    inst.pickupsound = "metal"
    MakeInventoryFloatable(inst, "small", 0.05, 1.2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/boningknife.xml"
    inst.components.inventoryitem.imagename = "boningknife"

    inst:AddComponent("slicer")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetConsumption(ACTIONS.SLICE, 2)
    inst.components.finiteuses:SetConsumption(ACTIONS.SLICESTACK, 2)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)
    return inst
end

-- 剔骨金刀（更多耐久，可切整组）
local function goldfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("goldboningknife")
    inst.AnimState:SetBuild("goldboningknife")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetScale(1.3, 1.3, 1.3)

    inst:AddTag("sharp")
    inst:AddTag("tool")
    inst:AddTag("slicer")
    inst:AddTag("professionalslicer")

    inst.pickupsound = "metal"
    MakeInventoryFloatable(inst, "small", 0.05, 1.2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/goldboningknife.xml"
    inst.components.inventoryitem.imagename = "goldboningknife"

    inst:AddComponent("slicer")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetConsumption(ACTIONS.SLICE, 1)
    inst.components.finiteuses:SetConsumption(ACTIONS.SLICESTACK, 1)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("boningknife", fn, assets),
       Prefab("goldboningknife", goldfn, goldassets)

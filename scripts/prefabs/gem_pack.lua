local assets =
{
    Asset("ANIM", "anim/ui_icepack_2x3.zip"),
    Asset("ANIM", "anim/gem_pack.zip"),
	Asset("IMAGE", "images/inventoryimages/gem_pack.tex"),
	Asset("ATLAS", "images/inventoryimages/gem_pack.xml"),
    --Asset("INV_IMAGE", "battlesong_container_open"),
}

local prefabs =
{

}

-----------------------------------------------------------------------------------------------

local SOUNDS =
{
    open  = "dontstarve/wilson/pickup_reeds",
    close = "dontstarve/wilson/pickup_reeds",
}

-----------------------------------------------------------------------------------------------

local function OnOpen(inst)
    if inst:HasTag("burnt") then
        return
    end
	inst.components.inventoryitem.atlasname = "images/inventoryimages/gem_pack_open.xml"
    inst.components.inventoryitem:ChangeImageName("gem_pack_open")
    inst.SoundEmitter:PlaySound(inst._sounds.open)
end

local function OnClose(inst)
    if inst:HasTag("burnt") then
        return
    end
	inst.components.inventoryitem.atlasname = "images/inventoryimages/gem_pack.xml"
    inst.components.inventoryitem:ChangeImageName("gem_pack")
    inst.SoundEmitter:PlaySound(inst._sounds.close)
end

local function OnPutInInventory(inst)
    inst.components.container:Close()
end

-----------------------------------------------------------------------------------------------

local function OnBurnt(inst)
    inst.components.container:DropEverything()
    DefaultBurntFn(inst)
end

-----------------------------------------------------------------------------------------------

local function OnSave(inst, data)
    if (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

-----------------------------------------------------------------------------------------------

local floatable_swap_data = { bank = "gem_pack", anim = "idle" }

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.entity:AddMiniMapEntity():SetPriority(5)
    inst.MiniMapEntity:SetIcon("gem_pack.tex")

    inst.AnimState:SetBank("gem_pack")
    inst.AnimState:SetBuild("gem_pack")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)

    MakeInventoryFloatable(inst, "small", 0.3, {0.8, 1, 0.8}, nil, nil, floatable_swap_data)

    inst.entity:SetPristine()

    inst:AddTag("portablestorage")

    if not TheWorld.ismastersim then
        return inst
    end

    inst._sounds = SOUNDS

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("gem_pack")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true
    inst.components.container.droponopen = true
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0.5)
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/gem_pack.xml"
	inst.components.inventoryitem:ChangeImageName("gem_pack")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

    MakeSmallBurnable(inst)
    MakeMediumPropagator(inst)

    inst.components.burnable:SetOnBurntFn(OnBurnt)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end


return Prefab("gem_pack", fn, assets, prefabs)

local function UpdatePosition(inst, target)
    local x, y, z = target.Transform:GetWorldPosition()
    if inst._x ~= x or inst._z ~= z then
        inst._x = x
        inst._z = z
        inst.Transform:SetPosition(x, 0, z)
    end
end

local function show_global_map_icon(inst)
    local icon = SpawnPrefab("globalmapicon")
    icon.entity:SetParent(inst.entity)
    icon.MiniMapEntity:SetPriority(21)
    if inst.target ~= nil then
        inst:ListenForEvent("onremove", function() inst:Remove() end, inst.target)
        inst:DoPeriodicTask(0, UpdatePosition, nil, inst.target)
        UpdatePosition(inst, inst.target)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetCanUseCache(false)
    inst.MiniMapEntity:SetDrawOverFogOfWar(true)
    inst.MiniMapEntity:SetIcon("wanderingtrader_icon.tex")
    inst.MiniMapEntity:SetPriority(21)

    inst.entity:SetCanSleep(false)
    inst:Hide()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, show_global_map_icon)

    inst.persists = false

    return inst
end

return Prefab("wanderingtrader_mapicon", fn)

require "prefabutil"

local easing = require("easing")

local assets =
{
    Asset("ANIM", "anim/firefighter.zip"),
    Asset("ANIM", "anim/firefighter_placement.zip"),
    Asset("ANIM", "anim/firefighter_meter.zip"),
}

local glow_assets =
{
    Asset("ANIM", "anim/firefighter_glow.zip"),
}

local prefabs =
{
    "snowball",
    "collapse_small",
    "firesuppressor_glow",
}

-- -- 发射投掷物逻辑
-- local function LaunchProjectile(inst, targetpos)        
--     local x, y, z = inst.Transform:GetWorldPosition()

--     local projectile = SpawnPrefab("snowball")
--     projectile.Transform:SetPosition(x, y, z)

--     local dx = targetpos.x - x
--     local dz = targetpos.z - z

--     local range = dx * dx + dz * dz             
--     local maxrange = TUNING.FIRE_DETECTOR_RANGE             

--     -- 根据范围配置调整发射速度和重力，保证命中率
--     if TUNING.FS_PLUS_RANGE_MULT <= 1.55 then
--         local speed = easing.linear(range, 15, 3, maxrange * maxrange)  
--         projectile.components.complexprojectile:SetHorizontalSpeed(speed)
--         projectile.components.complexprojectile:SetGravity(-25)     
--         projectile.components.complexprojectile:Launch(targetpos, inst, inst)
--     elseif TUNING.FS_PLUS_RANGE_MULT <= 2.15 then
--         -- 优化两倍范围时的初速度，解决雪球动画看起来没打到两倍范围边缘附近火焰的问题
--         local speed = easing.linear(range, 40, 6, maxrange * maxrange)          
--         projectile.components.complexprojectile:SetHorizontalSpeed(speed)
--         projectile.components.complexprojectile:SetGravity(-50)     
--         projectile.components.complexprojectile:Launch(targetpos, inst, inst)
--     else
--         local speed = easing.linear(range, 60, 10, maxrange * maxrange) 
--         projectile.components.complexprojectile:SetHorizontalSpeed(speed)
--         projectile.components.complexprojectile:SetGravity(-100)
--         projectile.components.complexprojectile:Launch(targetpos, inst, inst)
--     end
-- end


-- [核心优化] 发射投掷物逻辑 (按距离动态调整版)
-- 不再依赖 TUNING 的最大范围，而是根据“当前这一发要打多远”来决定力度
local function LaunchProjectile(inst, targetpos)        
    local x, y, z = inst.Transform:GetWorldPosition()

    local projectile = SpawnPrefab("snowball")
    projectile.Transform:SetPosition(x, y, z)

    local dx = targetpos.x - x
    local dz = targetpos.z - z
    
    -- 计算当前目标距离的平方
    local range = dx * dx + dz * dz             

    -- 这里的逻辑改为：根据实际距离分段处理
    -- 分界线：15格(225) 和 30格(900)
    
    -- [0~15格] (225)
    -- 基础速度15，增量3，重力-25
    if range <= 225 then
        local speed = easing.linear(range, 15, 3, 225)  
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-25)     
        
    -- [15~20格] (400)
    -- 基础速度20，增量6，重力-35
    elseif range <= 400 then
        local speed = easing.linear(range, 20, 6, 400)          
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-35)     
        
    -- [20~25格] (625)
    -- 基础速度25，增量9，重力-45
    elseif range <= 625 then
        local speed = easing.linear(range, 25, 9, 625)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-45)
    
    -- [25~30格] (900)
    -- 基础速度30，增量12，重力-55
    elseif range <= 900 then
        local speed = easing.linear(range, 30, 12, 900)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-55)

    -- [30~35格] (1225)
    -- 基础速度35，增量15，重力-65
    elseif range <= 1225 then
        local speed = easing.linear(range, 35, 15, 1225)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-65)

    -- [35~40格] (1600)
    -- 基础速度40，增量18，重力-75
    elseif range <= 1600 then
        local speed = easing.linear(range, 40, 18, 1600)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-75)

    -- [40~45格] (2025)
    -- 基础速度45，增量21，重力-85
    elseif range <= 2025 then
        local speed = easing.linear(range, 45, 21, 2025)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-85)

    -- [45~50格] (2500)
    -- 基础速度50，增量24，重力-95
    elseif range <= 2500 then
        local speed = easing.linear(range, 50, 24, 2500)
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-95)

    -- [50格以上] (兜底逻辑，适用于超远距离)
    -- 基础速度55，增量27，重力-105 (这里参数可以支持到55格甚至60格)
    else
        local speed = easing.linear(range, 55, 27, 3600) -- 分母设为60格的平方
        projectile.components.complexprojectile:SetHorizontalSpeed(speed)
        projectile.components.complexprojectile:SetGravity(-105)
    end
    
    projectile.components.complexprojectile:Launch(targetpos, inst, inst)
end



local function SpreadProtectionAtPoint(inst, firePos)
    inst.components.wateryprotection:SpreadProtectionAtPoint(firePos:Get())
end

-- 发现火灾的回调
local function OnFindFire(inst, firePos)
    if inst:IsAsleep() then
        inst:DoTaskInTime(1 + math.random(), SpreadProtectionAtPoint, firePos)
    else
        inst:PushEvent("putoutfire", { firePos = firePos })
    end
end

-- ===============================================
-- 自动浇水逻辑
-- ===============================================

-- 真正的浇水执行函数
local function DryingProtectAtPoint(inst, firePos)
    if inst.components.wateryprotection.WateringAtPoint then
        inst.components.wateryprotection.WateringAtPoint(firePos:Get())
    end
end

-- 发现缺水的回调
local function OnFindDrying(inst, firePos)
    inst:DoTaskInTime(2 + math.random(), DryingProtectAtPoint, firePos)
    if not inst:IsAsleep() then
        inst:PushEvent("putoutfire", { firePos = firePos })
    end
end

-- ===============================================
-- 状态指示灯逻辑 (保留原版机制，去除自定义配置)
-- ===============================================
local WarningColours =
{
    green = { 163 / 255, 255 / 255, 186 / 255 },
    yellow = { 255 / 255, 228 / 255, 81 / 255 },
    red = { 255 / 255, 146 / 255, 146 / 255 },
}

local function GetWarningLevelLight(level)
    return (level == nil and "off")
        or (level <= 0 and "green")
        or (level <= TUNING.EMERGENCY_BURNT_NUMBER and "yellow")
        or "red"
end

local function SetWarningLevelLight(inst, level)
    local anim = GetWarningLevelLight(level)
    if inst._warninglevel ~= anim then
        inst._warninglevel = anim
        if WarningColours[anim] ~= nil then
            inst.Light:SetColour(unpack(WarningColours[anim]))
            inst.Light:Enable(true)
            inst._glow.AnimState:PlayAnimation(anim, true)
            inst._glow._ison:set(true)
        else
            inst.Light:Enable(false)
            inst._glow._ison:set(false)
        end
    end
end

-- 关闭机器
local function TurnOff(inst, instant)
    inst.on = false
    inst.components.firedetector:Deactivate()
    
    if inst.components.dryingdetector then
        inst.components.dryingdetector:Deactivate()
    end

    if not inst:HasTag("fueldepleted") then 
        local randomizedStartTime = POPULATING
        inst:DoTaskInTime(0, inst.components.firedetector:ActivateEmergencyMode(randomizedStartTime)) 
    end

    inst.components.fueled:StopConsuming()

    SetWarningLevelLight(inst, nil)
    inst.sg:GoToState(instant and "idle_off" or "turn_off")
end

-- 开启机器
local function TurnOn(inst, instant)
    inst.on = true
    local isemergency = inst.components.firedetector:IsEmergency()
    if not isemergency then
        local randomizedStartTime = POPULATING
        inst.components.firedetector:Activate(randomizedStartTime)
        
        if inst.components.dryingdetector then
            inst.components.dryingdetector:Activate(randomizedStartTime)
        end
        
        SetWarningLevelLight(inst, 0)
    end

    -- 无限燃料判断
    -- 修改点：不再比较 == 1，而是直接判断布尔值
    if TUNING.FS_PLUS_INFINITE_FUEL then 
        inst.components.fueled:StopConsuming()
    else
        inst.components.fueled:StartConsuming()   
    end

    inst.sg:GoToState(instant and "idle_on" or (inst.sg:HasStateTag("light") and "turn_on_light" or "turn_on"), isemergency == true)
end

local function OnBeginEmergency(inst, level)
    SetWarningLevelLight(inst, math.huge)
    if not inst.on then
        inst.components.machine:TurnOn()
    end
end

local function OnEndEmergency(inst, level)
    if inst.on then
        inst.components.machine:TurnOff()
    end
end

local function OnBeginWarning(inst, level)
    SetWarningLevelLight(inst, level)
    if not inst.on then
        inst.sg:GoToState("light_on")
    end
end

local function OnUpdateWarning(inst, level)
    SetWarningLevelLight(inst, level)
end

local function OnEndWarning(inst, level)
    SetWarningLevelLight(inst, nil)
    if not inst.on then
        inst.sg:GoToState("light_off")
    end
end

local function OnFuelEmpty(inst)
    inst.components.machine:TurnOff()
end

local function OnAddFuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
    if inst.on == false then
        inst.components.machine:TurnOn()
    end
end

local function OnFuelSectionChange(new, old, inst)
    if inst._fuellevel ~= new then
        inst._fuellevel = new
        inst.AnimState:OverrideSymbol("swap_meter", "firefighter_meter", tostring(new))
    end
end

local function CanInteract(inst)
    return not inst.components.fueled:IsEmpty()
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.SoundEmitter:KillSound("firesuppressor_idle")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not (inst:HasTag("burnt") or inst.sg:HasStateTag("busy")) then
        inst.sg:GoToState("hit", inst.sg:HasStateTag("light"))
    end
end

local function getstatus(inst, viewer)
    return inst.components.fueled ~= nil
        and inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= .25
        and "LOWFUEL"
        or "ON"
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("firesuppressor_idle")
end

local function OnRemoveEntity(inst)
    inst._glow:Remove()
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil and inst.components.burnable.onburnt ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function oninit(inst)
    inst._glow.Follower:FollowSymbol(inst.GUID, "swap_glow", 0, 0, 0)
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/firesupressor_craft")
end

--------------------------------------------------------------------------

-- 放置时的预览圈比例（通过配置动态缩放）
local PLACER_SCALE = TUNING.FS_PLUS_RANGE_MULT

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false
            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()
            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")
            inst.helper.Transform:SetScale(PLACER_SCALE,PLACER_SCALE,PLACER_SCALE)
            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)
            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("firesuppressor.png")

    -- [无碰撞体积功能]
    if not TUNING.FS_PLUS_NO_COLLISION then
        MakeObstaclePhysics(inst, 1)
    end

    inst.AnimState:SetBank("firefighter")
    inst.AnimState:SetBuild("firefighter")
    inst.AnimState:PlayAnimation("idle_off")
    inst.AnimState:OverrideSymbol("swap_meter", "firefighter_meter", "10")

    inst:AddTag("hasemergencymode")
    inst:AddTag("structure")
    
    inst.Light:SetIntensity(.4)
    inst.Light:SetRadius(0.8) 
    inst.Light:SetFalloff(5)

    inst.Light:SetColour(unpack(WarningColours.green))
    inst.Light:Enable(false)

    if not TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._warninglevel = "off"
    inst._fuellevel = 10

    inst._glow = SpawnPrefab("firesuppressor_glow")
    inst:DoTaskInTime(0, oninit)
    inst:ListenForEvent("onbuilt", onbuilt)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = TurnOn
    inst.components.machine.turnofffn = TurnOff
    inst.components.machine.caninteractfn = CanInteract
    inst.components.machine.cooldowntime = 0.5

    inst:AddComponent("fueled")
    inst.components.fueled:SetDepletedFn(OnFuelEmpty)
    inst.components.fueled:SetTakeFuelFn(OnAddFuel)
    inst.components.fueled.accepting = true
    inst.components.fueled:SetSections(10)
    inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
    inst.components.fueled:InitializeFuelLevel(TUNING.FIRESUPPRESSOR_MAX_FUEL_TIME)
    inst.components.fueled.bonusmult = 5
    inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL

    -- [灭火检测组件]
    inst:AddComponent("firedetector")
    inst.components.firedetector:SetOnFindFireFn(OnFindFire)
    inst.components.firedetector:SetOnBeginEmergencyFn(OnBeginEmergency)
    inst.components.firedetector:SetOnEndEmergencyFn(OnEndEmergency)
    inst.components.firedetector:SetOnBeginWarningFn(OnBeginWarning)
    inst.components.firedetector:SetOnUpdateWarningFn(OnUpdateWarning)
    inst.components.firedetector:SetOnEndWarningFn(OnEndWarning)
    
    -- [自动浇水检测组件]
    if TUNING.FS_PLUS_AUTO_WATER then
        inst:AddComponent("dryingdetector")
        inst.components.dryingdetector:SetOnFindDryingFn(OnFindDrying)
    end

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.FIRESUPPRESSOR_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.FIRESUPPRESSOR_PROTECTION_TIME
    inst.components.wateryprotection.addcoldness = TUNING.FIRESUPPRESSOR_ADD_COLDNESS
    inst.components.wateryprotection:AddIgnoreTag("player")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst.LaunchProjectile = LaunchProjectile
    inst:SetStateGraph("SGfiresuppressor")

    inst.OnSave = onsave 
    inst.OnLoad = onload
    inst.OnEntitySleep = OnEntitySleep
    inst.OnRemoveEntity = OnRemoveEntity

    inst.components.machine:TurnOn()

    MakeHauntableWork(inst)

    return inst
end

-- 发光特效逻辑 (内部实现，无配置项)
local function onfade(inst)
    if inst._ison:value() then
        local df = math.max(.1, (1 - inst._fade) * .5)
        inst._fade = inst._fade + df
        if inst._fade >= 1 then
            inst._fade = 1
            inst._task:Cancel()
            inst._task = nil
        end
        inst.AnimState:OverrideMultColour(inst._fade, inst._fade, inst._fade, inst._fade)
    else
        local df = math.max(.1, inst._fade * .5)
        inst._fade = inst._fade - df
        if inst._fade <= 0 then
            inst._fade = 0
            inst._task:Cancel()
            inst._task = nil
        end
        inst.AnimState:OverrideMultColour(inst._fade, inst._fade, inst._fade, inst._fade)
    end
end

local function onisondirty(inst)
    if inst._task == nil and (inst._ison:value() and 1 or 0) ~= inst._fade then
        inst._task = inst:DoPeriodicTask(FRAMES, onfade, 0)
    end
end

local function oninitglow(inst)
    if inst._ison:value() then
        inst.AnimState:OverrideMultColour(1, 1, 1, 1)
        inst._fade = 1
    end
    inst:ListenForEvent("onisondirty", onisondirty)
end

local function glow_fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()
    inst.entity:AddNetwork()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.AnimState:SetBank("firefighter_glow")
    inst.AnimState:SetBuild("firefighter_glow")
    inst.AnimState:PlayAnimation("green", true)
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:OverrideMultColour(0, 0, 0, 0)
    inst._ison = net_bool(inst.GUID, "firesuppressor_glow._ison", "onisondirty")
    inst._fade = 0
    inst._task = nil
    inst:DoTaskInTime(0, oninitglow)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    inst.persists = false
    return inst
end

local function placer_postinit_fn(inst)
    local placer2 = CreateEntity()
    placer2.entity:SetCanSleep(false)
    placer2.persists = false
    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()
    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")
    local s = 1 / PLACER_SCALE
    placer2.Transform:SetScale(s, s, s)
    placer2.AnimState:SetBank("firefighter")
    placer2.AnimState:SetBuild("firefighter")
    placer2.AnimState:PlayAnimation("idle_off")
    placer2.AnimState:SetLightOverride(1)
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)
end

return Prefab("firesuppressor", fn, assets, prefabs),
    Prefab("firesuppressor_glow", glow_fn, glow_assets),
    MakePlacer("firesuppressor_placer", "firefighter_placement", "firefighter_placement", "idle", true, nil, nil, PLACER_SCALE, nil, nil, placer_postinit_fn)
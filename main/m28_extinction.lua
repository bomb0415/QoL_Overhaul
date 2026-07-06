---------------------------------------------------------------------
-- 模块 m28_extinction：防灭绝重生
-- 功能：监测关键生物数量，低于保底值时在附近重生
--       支持：野牛/闪电羊/蜘蛛巢/浣猫窝/蜂巢/发条骑士
---------------------------------------------------------------------

local ENABLED = GetModConfigData("extinction_prevent")
if not ENABLED then return end

local repsawn_time = (GetModConfigData("extinction_respawn_time") or 5) * 480

local respawn_list = {
    "beefalo",
    "lightninggoat",
    "spiderden",
    "catcoonden",
    "beehive",
    "knight",
}

local leastnum = {}
for k, v in ipairs(respawn_list) do
    leastnum[v] = GetModConfigData("extinction_min_count") or 2
end

-- 缓存计数 + 节流：避免每次死亡都遍历全图 Ents（O(n)扫描）
local _last_scan = {}
local _cached_count = {}
local SCAN_COOLDOWN = 10  -- 同种生物 10 秒内最多扫描一次

local function count_prefab(prefab_name)
    local now = GetTime()
    if _last_scan[prefab_name] and (now - _last_scan[prefab_name]) < SCAN_COOLDOWN then
        return _cached_count[prefab_name] or 0
    end

    local count = 0
    for k, v in pairs(Ents) do
        if v.prefab == prefab_name and v:IsValid() then
            count = count + 1
        end
    end

    _last_scan[prefab_name] = now
    _cached_count[prefab_name] = count
    return count
end

-- 监测各实体死亡
for k, v in ipairs(respawn_list) do
    AddPrefabPostInit(v, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("onremove", function()
            local pos = Vector3(inst.Transform:GetWorldPosition())
            TheWorld:DoTaskInTime(0, function()
                local current_num = count_prefab(v)
                if current_num < leastnum[v] then
                    TheWorld:PushEvent(v .. "_death", { name = v, pos = pos })
                end
            end)
        end)
    end)
end

-- TheWorld 监听死亡事件并计时重生
AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then return end

    if inst._qol_spawnlist == nil then
        inst._qol_spawnlist = {}
    end

    for k, v in ipairs(respawn_list) do
        inst:ListenForEvent(v .. "_death", function(inst, data)
            table.insert(inst._qol_spawnlist, data)
            local i = 0
            while inst.components.timer:TimerExists(v .. "_" .. i) do
                i = i + 1
            end
            if inst.components.timer then
                inst.components.timer:StartTimer(v .. "_" .. i, repsawn_time)
            end
        end)
    end

    -- 计时器到期 → 重生
    local function ontimerdone(inst, data)
        for k, v in ipairs(inst._qol_spawnlist) do
            if v.name == string.split(data.name, "_")[1] then
                local pos = FindNearbyLand(v.pos, 15) or v.pos
                local tryspawn = SpawnPrefab(v.name)
                tryspawn.Transform:SetPosition(pos:Get())
                table.remove(inst._qol_spawnlist, k)
                break
            end
        end
    end

    if not inst.components.timer then
        inst:AddComponent("timer")
    end
    inst:ListenForEvent("timerdone", ontimerdone)

    -- 存档
    local old_save = inst.OnSave
    inst.OnSave = function(inst, data)
        if old_save then old_save(inst, data) end
        if data then data.qol_spawnlist = inst._qol_spawnlist end
    end
    local old_load = inst.OnLoad
    inst.OnLoad = function(inst, data)
        if old_load then old_load(inst, data) end
        inst._qol_spawnlist = (data ~= nil and data.qol_spawnlist) or {}
    end
end)

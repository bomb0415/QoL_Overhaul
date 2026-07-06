local NOTAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO", "burnt", "player", "monster", "smallcreature", "animal", "firefly" }
local DETECTAGS = { "farm_plant" }
local TURN_ON_DELAY = 13 * FRAMES
local _moisturegrid = nil
local farming_manager = TheWorld.components.farming_manager

local DryingDetector = Class(function(self, inst)
        self.inst = inst
        self.range = TUNING.FIRE_DETECTOR_RANGE
        self.detectPeriod = TUNING.FIRE_DETECTOR_PERIOD
        self.onfinddrying = nil
        self.detectedItems = {}
        self.detectTask = nil
    end,
    nil,
    {
    }
)

function DryingDetector:SetOnFindDryingFn(fn)
    self.onfinddrying = fn
end

local function Cancel(inst, self)
    if self.detectTask ~= nil then
        self.detectTask:Cancel()
        self.detectTask = nil
    end
end

local function OnDetectedItemTimeOut(inst, self, target)
    self.detectedItems[target] = nil
end

local function RegisterDetectedItem(inst, self, target)
    self.detectedItems[target] = inst:DoTaskInTime(2, OnDetectedItemTimeOut, self, target)
end

local function CheckTargetScore(target)
    if not target:IsValid() then
        return 0
    elseif not target:HasTag("farm_plant") then
        return 0
    end

    local x, y, z = target.Transform:GetWorldPosition()
    if farming_manager:IsSoilMoistAtPoint(x, y, z) == false then
        return 8
    end

    return 0
end

local function LookForDryFarm(inst, self, force)
    if not force and inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, self.range, nil, NOTAGS, nil)
    local target = nil
    local targetscore = 0
    
    for index, value in ipairs(ents) do
        if not self.detectedItems[value] then
            if value:HasTag("farm_plant") then
                local score, force = CheckTargetScore(value)
                if force then
                    target = value
                    break
                elseif score > targetscore then
                    targetscore = score
                    target = value
                end
            end
        end
    end
    if target ~= nil then
        RegisterDetectedItem(inst, self, target)
        if self.onfinddrying ~= nil then
            self.onfinddrying(inst, target:GetPosition())
        end
    end
end

function DryingDetector:Activate(randomizedStartTime)
    Cancel(self.inst, self)
    self.detectTask = self.inst:DoPeriodicTask(self.detectPeriod, LookForDryFarm,
        randomizedStartTime and TURN_ON_DELAY + math.random() * self.detectPeriod or TURN_ON_DELAY, self)
end

function DryingDetector:Deactivate()
    Cancel(self.inst, self)
end

return DryingDetector
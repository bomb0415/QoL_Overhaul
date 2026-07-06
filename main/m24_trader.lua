---------------------------------------------------------------------
-- 模块：流浪商人优化（m24_trader）
-- 参考：3459779337 原版内容修改 — set33
-- 功能：地图图标 + 固定位置
---------------------------------------------------------------------

local ENABLED = GetModConfigData("wandering_trader")
if not ENABLED then return end

-- 固定位置大脑（StandStill，不移动）
local WanderingTraderBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function WanderingTraderBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return self.inst.sg.mem.trading end, "Trading",
            FaceEntity(self.inst, function()
                return FindClosestPlayerToInst(self.inst, 6, true)
            end, function(inst, target)
                return inst:IsNear(target, 6)
            end)
        ),
        StandStill(self.inst),
    }, .25)
    self.bt = BT(self.inst, root)
end

AddPrefabPostInit("wanderingtrader", function(inst)
    if not TheWorld.ismastersim then return end

    -- 固定到绚丽之门附近
    inst:DoTaskInTime(0, function()
        -- 禁用路线跟随（防止拉回原位置）
        if inst.components.worldroutefollower ~= nil then
            inst.components.worldroutefollower:SetPaused(true, "qol_fixed")
        end

        local portal = FindEntity(inst, 10000, function(target)
            return target.prefab == "multiplayer_portal"
        end)
        if portal ~= nil then
            local x, y, z = portal.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x + 5, 0, z + 5)
        end
    end)

    -- 添加地图图标
    inst:DoTaskInTime(0.1, function()
        local fx = SpawnPrefab("wanderingtrader_mapicon")
        if fx ~= nil then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx.target = inst
        end
    end)

    -- 替换大脑为固定位置
    inst:SetBrain(WanderingTraderBrain)
end)

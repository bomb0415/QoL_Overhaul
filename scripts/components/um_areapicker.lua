-- 独立的范围收割组件，不依赖镰刀模组
-- 核心逻辑：搜索范围内所有可采集实体，批量执行原版收割方法

local PICK_MUSTNOT_TAG = {"notreadyforharvest", "stump", "withered", "FX", "NOCLICK", "INLIMBO"}

local UmAreaPicker = Class(function(self, inst)
    self.inst = inst
    self.radius = 6  -- 收割半径，6单位≈1.5格地皮

    self.inst:AddTag("um_areapicker")

    -- 设置 UM_AREAPICK 动作的耐久消耗
    if self.inst.components.finiteuses ~= nil then
        local action = ACTIONS.UM_AREAPICK
        if action ~= nil and self.inst.components.finiteuses.consumption[action] == nil then
            self.inst.components.finiteuses:SetConsumption(action, 1)
        end
    end
end)

function UmAreaPicker:OnRemoveFromEntity()
    self.inst:RemoveTag("um_areapicker")
    if self.inst.components.finiteuses ~= nil then
        local action = ACTIONS.UM_AREAPICK
        if action ~= nil then
            self.inst.components.finiteuses:SetConsumption(action)
        end
    end
end

function UmAreaPicker:SetRadius(radius)
    self.radius = radius
end

function UmAreaPicker:Pick(doer, target)
    local x, y, z = doer.Transform:GetWorldPosition()
    local radius = self.radius

    -- 蜂蜜调味buff双倍范围
    if doer.components.debuffable ~= nil and doer.components.debuffable:HasDebuff("buff_workeffectiveness") then
        radius = radius * 2
    end

    -- 搜索范围内的可采集实体（三种搜索合并去重）
    local found = {}
    local ents = {}

    -- 1. 基础可采集植物（草、树枝、浆果丛等）
    --    必须同时有 plant 和 pickable 标签，排除地上花朵（只有pickable没有plant）
    local plants = TheSim:FindEntities(x, y, z, radius, {"plant", "pickable"}, PICK_MUSTNOT_TAG)
    for _, v in ipairs(plants) do
        if not found[v] then
            found[v] = true
            table.insert(ents, v)
        end
    end

    -- 2. 农场作物、蘑菇农场、晾肉架、诱饵植物等（排除蜂箱）
    local extra_tags = {"readyforharvest", "dried", "takeshelfitem"}
    for _, tag in ipairs(extra_tags) do
        local items = TheSim:FindEntities(x, y, z, radius, {tag}, PICK_MUSTNOT_TAG)
        for _, v in ipairs(items) do
            -- 排除蜂箱（beebox）和巨型蜂箱（mega_beebox），镰刀不应采集蜂蜜
            if not found[v]
                and v.prefab ~= "beebox"
                and v.prefab ~= "mega_beebox"
                and (v:HasTag("pickable") or v:HasTag("readyforharvest")
                    or v:HasTag("dried")
                    or v:HasTag("takeshelfitem")
                    or (v:HasTag("HACK_workable") and v:HasTag("plant"))) then
                found[v] = true
                table.insert(ents, v)
            end
        end
    end

    -- 3. 单独处理 harvestable tag（用于蘑菇农场等），但仍排除蜂箱
    local harvestable_items = TheSim:FindEntities(x, y, z, radius, {"harvestable"}, PICK_MUSTNOT_TAG)
    for _, v in ipairs(harvestable_items) do
        -- 排除蜂箱（beebox）和巨型蜂箱（mega_beebox）
        if not found[v]
            and v.prefab ~= "beebox"
            and v.prefab ~= "mega_beebox"
            and v:HasTag("harvestable") then
            found[v] = true
            table.insert(ents, v)
        end
    end

    -- 4. 补充搜索：用组件检测抓取没有显式 pickable 标签但能被采集的实体
    local candidates = TheSim:FindEntities(x, y, z, radius, nil, PICK_MUSTNOT_TAG)
    for _, v in ipairs(candidates) do
        if not found[v] then
            -- 有 pickable 组件 + 可以被采集
            if v.components.pickable ~= nil and v.components.pickable:CanBePicked() then
                found[v] = true
                table.insert(ents, v)
            -- 有 harvestable 组件
            elseif v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() then
                found[v] = true
                table.insert(ents, v)
            -- 有 crop 组件（成熟作物）
            elseif v.components.crop ~= nil then
                local crop = v.components.crop
                if not crop:IsWithered() and crop:IsReadyForHarvest() then
                    found[v] = true
                    table.insert(ents, v)
                end
            end
        end
    end

    -- 遍历收割
    local collected = 0
    local finiteuses = self.inst.components.finiteuses
    local action = ACTIONS.UM_AREAPICK
    local uses = finiteuses ~= nil and action ~= nil
        and (finiteuses:GetUses() / (finiteuses.consumption[action] or 1))
        or 255

    for _, ent in ipairs(ents) do
        if collected >= uses then break end

        local success = false
        local harvest = ent.components.crop
                     or ent.components.dryer
                     or ent.components.harvestable

        if ent.components.pickable ~= nil then
            success = ent.components.pickable:Pick(doer)
        elseif harvest ~= nil then
            success = harvest:Harvest(doer)
        elseif ent.components.shelf ~= nil then
            success = ent.components.shelf:TakeItem(doer)
        elseif ent.components.hackable ~= nil then
            local hackable = ent.components.hackable
            local hacksleft = hackable.hacksleft
            hackable:Hack(doer, hacksleft)
            collected = collected + 1
            if finiteuses ~= nil and action ~= nil then
                local cost = (hacksleft - hackable.hacksleft) * (finiteuses.consumption[action] or 1) * 2
                finiteuses:Use(cost)
            end
        end

        if success then
            collected = collected + 1
        end
    end

    if collected >= 1 then
        -- 范围收割的额外耐久消耗（主目标由动作本身消耗1次）
        if finiteuses ~= nil and action ~= nil then
            local cost = (collected - 1) * (finiteuses.consumption[action] or 1)
            cost = math.ceil(cost - math.random())
            finiteuses:Use(cost)
        end

        -- 筋肉值增益（沃尔夫冈）
        if doer.components.mightiness ~= nil then
            doer.components.mightiness:DoDelta(math.ceil(collected / 5))
        end

        -- 临时清除与小作物的碰撞
        doer.Physics:ClearCollidesWith(COLLISION.SMALLOBSTACLES)
        doer:DoTaskInTime(3, function(doer)
            if doer:IsValid() then
                doer.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
            end
        end)

        return true
    end

    return false
end

return UmAreaPicker

---------------------------------------------------------------------
-- 模块：帐篷&遮阳棚强化（m12_tent）
-- 参考：2927761874 原版改动 — init_tuning + sleepingbaguser postinit
--       异世三叶草 (3728543058) — 无限耐久 + 微光 + 配方
---------------------------------------------------------------------

local ENABLED = GetModConfigData("tent_enhance")
if not ENABLED then return end

local STRUCTURES = { "tent", "siestahut" }

for _, prefab in ipairs(STRUCTURES) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end

        -- 1) 无限耐久：起床后把耐久补满
        local _onwake = inst.components.sleepingbag.onwake
        inst.components.sleepingbag.onwake = function(inst, sleeper, nostatechange)
            if _onwake ~= nil then
                _onwake(inst, sleeper, nostatechange)
            end
            if inst.components.finiteuses ~= nil and inst.components.finiteuses.total ~= nil then
                inst.components.finiteuses:SetUses(inst.components.finiteuses.total)
            end
        end

        -- 2) 3倍回血速度
        inst.components.sleepingbag.health_tick = TUNING.SLEEP_HEALTH_PER_TICK * 3

        -- 2b) 2倍饥饿消耗（直接改 tick 值，确保帐篷和遮阳棚效果一致）
        --     遮阳棚原版只有帐篷的 1/3，靠 hunger_bonus_mult 不够
        inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK * 2
    end)

    -- 3) 自带微光
    AddPrefabPostInit(prefab, function(inst)
        if inst.Light == nil or not inst.Light:IsValid() then
            inst.entity:AddLight()
        end
        inst.Light:SetRadius(2.5)
        inst.Light:SetFalloff(0.8)
        inst.Light:SetIntensity(0.6)
        inst.Light:SetColour(245/255, 225/255, 180/255)
        inst.Light:Enable(true)
    end)
end

---------------------------------------------------------------------
-- 4) 优化配方
---------------------------------------------------------------------
AddRecipePostInit("tent", function(recipe)
    recipe.ingredients = {
        Ingredient("silk", 4),
        Ingredient("twigs", 4),
        Ingredient("rope", 2),
    }
    recipe.level = TECH.SCIENCE_ONE
end)

AddRecipePostInit("siestahut", function(recipe)
    recipe.ingredients = {
        Ingredient("silk", 2),
        Ingredient("boards", 2),
        Ingredient("rope", 2),
    }
    recipe.level = TECH.SCIENCE_ONE
end)

---------------------------------------------------------------------
-- 5) 睡眠：先回血 → 回满后再恢复血量上限
--    恢复上限期间饥饿消耗2倍（debuff）
---------------------------------------------------------------------
AddComponentPostInit("sleepingbaguser", function(self)
    local _DoSleep = self.DoSleep
    local _DoWakeUp = self.DoWakeUp

    self.DoSleep = function(self, bed)
        _DoSleep(self, bed)

        local prefab = bed.prefab
        if prefab ~= "tent" and prefab ~= "siestahut" then
            return
        end

        -- 睡眠期间2倍饥饿消耗：已在 PostInit 中直接改 hunger_tick，无需 hook

        -- 每tick：先确认血回满了才恢复上限
        if self.healthpenaltytask == nil then
            local period = bed.components.sleepingbag.tick_period
            self.healthpenaltytask = self.inst:DoPeriodicTask(period, function()
                local health = self.inst.components.health
                if health == nil or health:GetPenaltyPercent() <= 0 then
                    return
                end
                -- 血量到达当前惩罚上限后，才开始恢复血量上限
                local capped_max = health:GetMaxWithPenalty()
                if health.currenthealth >= capped_max - 1 then
                    health:DeltaPenalty(-(bed.components.sleepingbag.health_tick / 200))
                end
            end)
        end
    end

    self.DoWakeUp = function(self, nostatechange)
        if self.healthpenaltytask ~= nil then
            self.healthpenaltytask:Cancel()
            self.healthpenaltytask = nil
        end
        _DoWakeUp(self, nostatechange)
    end
end)

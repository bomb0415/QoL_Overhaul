---------------------------------------------------------------------
-- 模块：懒人法杖CD模式（m06_orangestaff）
-- 作者：落叶异世之力
-- 参考：原版改动 — staffs
-- 原理：移除 finiteuses → 加 rechargeable → CD期间移除 blinkstaff 组件
---------------------------------------------------------------------

local ENABLED = GetModConfigData("orangestaff_cooldown")
if not ENABLED then return end

local COOLDOWN = 5

local function onblink(staff, pos, caster)
    -- 未充能：取消已调度的传送任务，不触发冷却
    if not (caster and staff.components.rechargeable:IsCharged()) then
        if staff.components.blinkstaff.blinktask ~= nil then
            staff.components.blinkstaff.blinktask:Cancel()
            staff.components.blinkstaff.blinktask = nil
        end
        return
    end

    -- 已充能：消耗充能 → 移除 blinkstaff 组件 → CD后恢复
    staff.components.rechargeable:Discharge(COOLDOWN)
    staff:RemoveComponent("blinkstaff")
    staff:DoTaskInTime(COOLDOWN, function()
        if staff:IsValid() then
            staff:AddComponent("blinkstaff")
            staff.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
            staff.components.blinkstaff.onblinkfn = onblink
        end
    end)
end

AddPrefabPostInit("orangestaff", function(inst)
    if not TheWorld.ismastersim then return end

    inst:RemoveComponent("finiteuses")
    inst:AddComponent("rechargeable")
    inst.components.blinkstaff.onblinkfn = onblink
end)

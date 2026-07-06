---------------------------------------------------------------------
-- 模块：鬼魂移动速度调节（m02_ghost）
-- 作者：落叶异世之力
-- 原理：玩家变鬼魂后，修改 locomotor 组件的 walkspeed/runspeed
---------------------------------------------------------------------

local GHOST_SPEED = GetModConfigData("ghost_speed")

-- 速度为0表示"关闭/原版"，不修改
if GHOST_SPEED == nil or GHOST_SPEED == 0 then
    return
end

---------------------------------------------------------------------
-- 设置鬼魂速度
---------------------------------------------------------------------
local function SetGhostSpeed(inst)
    if inst.components.locomotor ~= nil then
        inst.components.locomotor.walkspeed = GHOST_SPEED
        inst.components.locomotor.runspeed = GHOST_SPEED
    end
end

---------------------------------------------------------------------
-- 监听玩家鬼魂状态变化
---------------------------------------------------------------------
AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end

    -- 当前已经是鬼魂则立即设置
    if inst:HasTag("playerghost") then
        inst:DoTaskInTime(0, SetGhostSpeed)
    end

    -- 变为鬼魂时设置
    inst:ListenForEvent("ms_becameghost", function()
        SetGhostSpeed(inst)
    end)
end)

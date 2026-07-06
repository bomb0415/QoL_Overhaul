---------------------------------------------------------------------
-- 模块 m32_firesuppressor：雪球机增强
-- 完全照搬异世三叶草/yssy/main/firesuppressor.lua
---------------------------------------------------------------------

-- 始终开启功能（无配置开关）
TUNING.FS_PLUS_INFINITE_FUEL = true   -- 无限燃料
TUNING.FS_PLUS_AUTO_WATER = true      -- 自动浇水
TUNING.FS_PLUS_NO_COLLISION = true    -- 移除碰撞体积
TUNING.FS_PLUS_PROTECT_CAMPFIRE = true -- 不灭营火

-- 范围（保留配置项）
TUNING.FIRE_DETECTOR_RANGE = 15 * math.floor(GetModConfigData("range_mult") + 0.4)
TUNING.FS_PLUS_RANGE_MULT = GetModConfigData("range_mult")

-- 核心逻辑：让雪球可以加湿土壤
local function WateringAtPoint(x, y, z, dist, noextinguish)
    local addwetness = 100
    if addwetness and TheWorld.components.farming_manager ~= nil then
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, y, z, addwetness)
    end
end

AddComponentPostInit("wateryprotection", function(self)
    self.WateringAtPoint = WateringAtPoint
end)

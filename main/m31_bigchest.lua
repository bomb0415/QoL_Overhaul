---------------------------------------------------------------------
-- 模块 m31_bigchest：25格大箱子
-- 来源：异世三叶草/yssy/main/big_chest.lua
-- 功能：箱子和冰箱容器升级为25格（5×5）
---------------------------------------------------------------------

if GetModConfigData("big_chest_enabled") then
    local containers = require "containers"

    local params = {}

    local containers_widgetsetup_prev = containers.widgetsetup
    function containers.widgetsetup(container, prefab, data, ...)
        local t = params[prefab or container.inst.prefab]
        if t ~= nil then
            for k, v in pairs(t) do
                container[k] = v
            end
            container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        else
            containers_widgetsetup_prev(container, prefab, data, ...)
        end
    end

    local function makeChest()
        local container = {
            widget = {
                slotpos = {},
                animbank = "ui_chest_5x5",
                animbuild = "ui_chest_5x5",
                pos = Vector3(0, 200, 0),
                side_align_tip = 160,
            },
            type = "chest",
        }
        for y = 3, -1, -1 do
            for x = -1, 3 do
                table.insert(container.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
            end
        end
        return container
    end

    params.treasurechest = makeChest()
    params.icebox = makeChest()

    for k, v in pairs(params) do
        containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
    end
end

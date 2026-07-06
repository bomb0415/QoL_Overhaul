---------------------------------------------------------------------
-- 模块：衣柜25格空间（m04_wardrobe）
-- 作者：落叶异世之力
-- 参考：原版改动 — wardrobe + init_containers
---------------------------------------------------------------------

local ENABLED = GetModConfigData("wardrobe_25_slots")
if not ENABLED then return end

---------------------------------------------------------------------
-- 物品筛选：只有可装备/工具/武器/热石/针线包等能放进衣柜
---------------------------------------------------------------------
local function WardrobeItemCheck(container, item, slot)
    return item:HasTag("_equippable")
        or item:HasTag("tool")
        or item:HasTag("weapon")
        or item:HasTag("heatrock")
        or item:HasTag("pocketwatch")
        or item:HasTag("reloaditem_ammo")
        or item:HasTag("fan")
        or item.prefab == "razor"
        or item.prefab == "beef_bell"
        or item.prefab == "sewing_kit"
        or item.prefab == "sewing_tape"
        or item.prefab == "pocketwatch_dismantler"
end

---------------------------------------------------------------------
-- 注册衣柜容器参数（5×5 = 25格）
---------------------------------------------------------------------
local containers = require("containers")

local slotpos = {}
for y = 2.5, -1.5, -1 do
    for x = 0, 4 do
        table.insert(slotpos, Vector3(80 * x - 160, 80 * y - 40, 0))
    end
end

containers.params.wardrobe = {
    widget = {
        slotpos    = slotpos,
        animbank   = nil,
        animbuild  = nil,
        bgatlas    = "images/dragonflycontainerborder.xml",
        bgimage    = "dragonflycontainerborder.tex",
        bgimagetint = { r = 0.82, g = 0.77, b = 0.7, a = 1 },
        pos        = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
    itemtestfn = WardrobeItemCheck,
    right = true,
}

---------------------------------------------------------------------
-- 扩大最大格子数以容纳25格
---------------------------------------------------------------------
if containers.MAXITEMSLOTS == nil or containers.MAXITEMSLOTS < 25 then
    containers.MAXITEMSLOTS = 25
end

-- 为 container_classified 补充网络变量
AddPrefabPostInit("container_classified", function(inst)
    if #inst._itemspool < containers.MAXITEMSLOTS then
        for i = #inst._itemspool + 1, containers.MAXITEMSLOTS do
            table.insert(inst._itemspool,
                net_entity(inst.GUID, "container._items[" .. tostring(i) .. "]", "items[" .. tostring(i) .. "]dirty"))
        end
    end
end)

---------------------------------------------------------------------
-- 为衣柜预制体添加容器
---------------------------------------------------------------------
AddPrefabPostInit("wardrobe", function(inst)
    inst:AddTag("dressable")

    if not TheWorld.ismastersim then
        return
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("wardrobe")

    -- 锤子砸掉时掉落物品
    local _onwork = inst.components.workable.onwork
    local _onfinish = inst.components.workable.onfinish
    inst.components.workable:SetOnWorkCallback(function(inst, worker)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
        if _onwork then _onwork(inst, worker) end
    end)
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
        end
        if _onfinish then _onfinish(inst, worker) end
    end)
end)

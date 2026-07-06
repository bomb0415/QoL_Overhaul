---------------------------------------------------------------------
-- 模块 m36_beehat：养蜂帽采蜜不被叮
-- 来源：m30_daily.lua
-- 功能：戴养蜂帽采蜜不会被蜜蜂攻击
---------------------------------------------------------------------

if not GetModConfigData("bee_ding") then return end

if TheNet:GetIsServer() then
    AddPrefabPostInit("beebox", function(inst)
        if not TheWorld.ismastersim then return end
        if inst.components.harvestable then
            local old = inst.components.harvestable.onharvestfn
            inst.components.harvestable.onharvestfn = function(inst, picker, ...)
                if picker and picker.components.inventory and picker.components.inventory.equipslots and
                    picker.components.inventory.equipslots.head and
                    picker.components.inventory.equipslots.head.prefab == "beehat" then
                    return old(inst, nil, ...)
                else
                    return old(inst, picker, ...)
                end
            end
        end
    end)
end

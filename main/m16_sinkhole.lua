---------------------------------------------------------------------
-- 模块：蚁狮陷坑可填补（m16_sinkhole）
-- 参考：3454347475 Smallchanges — antlion_sinkhole.lua
-- 原理：去掉 NOCLICK → 添加 constructionsite → 15石头填坑
---------------------------------------------------------------------

local ENABLED = GetModConfigData("fill_sinkhole")
if not ENABLED then return end

-- 注册蓝图配方：15块石头
CONSTRUCTION_PLANS.antlion_sinkhole = {
    Ingredient("rocks", 15),
}

AddPrefabPostInit("antlion_sinkhole", function(inst)
    -- 允许玩家选中
    inst:AddTag("constructionsite")
    inst:RemoveTag("NOCLICK")

    if not TheWorld.ismastersim then return end

    inst:AddComponent("constructionsite")
    inst.components.constructionsite:SetConstructionPrefab("construction_container")
    inst.components.constructionsite:SetOnConstructedFn(function(inst)
        if inst.components.constructionsite:IsComplete() then
            -- 填满 → 坑消失
            local fx = SpawnPrefab("collapse_big")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("rock")
            inst:Remove()
        end
    end)
end)

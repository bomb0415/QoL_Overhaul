---------------------------------------------------------------------
-- 模块：支柱免疫地震+酸雨（m20_pillar）
-- 参考：3459779337 原版内容修改 — set11
---------------------------------------------------------------------

local ENABLED = GetModConfigData("pillar_protect")
if not ENABLED then return end

local PILLAR_RADIUS = TUNING.VOIDCLOTH_UMBRELLA_DOME_RADIUS or 6

local pillars = { "support_pillar", "support_pillar_dreadstone" }

for _, prefab in ipairs(pillars) do
    AddPrefabPostInit(prefab, function(inst)
        -- 1) 酸雨保护罩
        inst:AddComponent("raindome")
        inst.components.raindome:SetRadius(PILLAR_RADIUS)

        if not TheWorld.ismastersim then return end

        -- 2) 地震免疫：拦截 startquake 事件，支柱不会震坏
        local _old_ListenForEvent = inst.ListenForEvent
        inst.ListenForEvent = function(inst, name, ...)
            if name == "startquake" then
                return  -- 忽略地震事件
            end
            return _old_ListenForEvent(inst, name, ...)
        end

        -- 3) 酸雨保护：根据 quake_blocker 标签切换
        local function UpdateRainDome()
            if inst:HasTag("quake_blocker") then
                inst.components.raindome:Enable()
            else
                inst.components.raindome:Disable()
            end
        end
        UpdateRainDome()

        inst:ListenForEvent("addtag", function(_, data)
            if data == "quake_blocker" then
                inst.components.raindome:Enable()
            end
        end)
        inst:ListenForEvent("removetag", function(_, data)
            if data == "quake_blocker" then
                inst.components.raindome:Disable()
            end
        end)

        inst:ListenForEvent("death", function()
            inst.components.raindome:Disable()
        end)
    end)
end

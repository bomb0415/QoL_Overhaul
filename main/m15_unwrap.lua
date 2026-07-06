---------------------------------------------------------------------
-- 模块：拆包裹进物品栏（m15_unwrap）
-- 参考：3459779337 原版内容修改 — unwrappable postinit
-- 原理：完全替换拆包逻辑，生成物品时优先 GiveItem，满了才掉地
---------------------------------------------------------------------

local ENABLED = GetModConfigData("unwrap_to_inventory")
if not ENABLED then return end

AddComponentPostInit("unwrappable", function(self)
    local _Unwrap = self.Unwrap

    -----------------------------------------------------------------
    -- 内部拆包函数（给延迟回调用的）
    -----------------------------------------------------------------
    local function DoUnwrap(inst, self, doer)
        self:Unwrap(doer and doer:IsValid() and doer or nil, true)
    end

    self.Unwrap = function(self, doer, nodelay)
        local delay = not nodelay and self.unwrapdelayfn and self.unwrapdelayfn(self.inst, doer) or nil
        local pos = self.inst:GetPosition()
        pos.y = 0

        -- 调整掉落位置到拆包玩家面前
        if self.itemdata ~= nil and doer ~= nil and doer:IsValid()
            and self.inst.components.inventoryitem ~= nil then
            local owner = self.inst.components.inventoryitem:GetGrandOwner()
            if owner ~= nil then
                if owner ~= doer and owner:HasTag("pocketdimension_container") then
                    owner = doer.components.inventory ~= nil
                        and doer.components.inventory:GetOpenContainerProxyFor(owner) or nil
                    if owner ~= nil then
                        pos.x, pos.y, pos.z = owner.Transform:GetWorldPosition()
                        pos.y = 0
                    else
                        owner = doer
                    end
                end
                if owner == doer or delay then
                    local doerpos = doer:GetPosition()
                    local offset = FindWalkableOffset(doerpos, doer.Transform:GetRotation() * DEGREES, 1, 8, false, true)
                    if offset ~= nil then
                        pos.x = doerpos.x + offset.x
                        pos.z = doerpos.z + offset.z
                    else
                        pos.x, pos.z = doerpos.x, doerpos.z
                    end
                    if delay then
                        doer.components.inventory:DropItem(self.inst, true, false, pos)
                    end
                end
            end
        end

        -- 有延迟动画 → 延迟后执行拆包
        if delay then
            self.inst:DoTaskInTime(delay, DoUnwrap, self, doer)
            return
        end

        -- 执行拆包：生成物品 → 先塞背包 → 满了才掉地
        if self.itemdata ~= nil then
            local creator = self.origin ~= nil and TheWorld.meta.session_identifier ~= self.origin
                and { sessionid = self.origin } or nil

            for i, v in ipairs(self.itemdata) do
                local item = SpawnPrefab(v.prefab, v.skinname, v.skin_id, creator)
                if item ~= nil and item:IsValid() then
                    if item.Physics ~= nil then
                        item.Physics:Teleport(pos:Get())
                    else
                        item.Transform:SetPosition(pos:Get())
                    end
                    item:SetPersistData(v.data)

                    if item.components.inventoryitem ~= nil then
                        if doer and doer.components.inventory and item.prefab ~= "giftsurprise" then
                            doer.components.inventory:GiveItem(item)
                        else
                            item.components.inventoryitem:OnDropped(true, .5)
                        end
                    end

                    item:PushEvent("unwrappeditem", { bundle = self.inst, doer = doer })
                end
            end
            self.itemdata = nil
        end

        self.inst:PushEvent("unwrapped", { doer = doer })
        if self.onunwrappedfn ~= nil then
            self.onunwrappedfn(self.inst, pos, doer)
        end
    end
end)

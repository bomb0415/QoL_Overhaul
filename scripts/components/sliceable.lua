-- sliceable组件：添加到可切割的食物上
-- 参考HoF模组(3659712335)的sliceable组件

local function onsliceable(self)
    if self.canbesliced then
        self.inst:AddTag("sliceable")
    else
        self.inst:RemoveTag("sliceable")
    end
end

local function onslicestack(self)
    if self.canslicestack then
        self.inst:AddTag("sliceablestack")
    else
        self.inst:RemoveTag("sliceablestack")
    end
end

local Sliceable = Class(function(self, inst)
    self.inst = inst
    self.product = nil
    self.productfn = nil
    self.slicesize = 1
    self.canslicestack = false
    self.canbesliced = true
    self.onslicefn = nil
    self.onslicestackfn = nil
end,
nil,
{
    canbesliced = onsliceable,
    canslicestack = onslicestack,
})

function Sliceable:SetOnSliceFn(fn)
    self.onslicefn = fn
end

function Sliceable:SetOnSliceStackFn(fn)
    self.onslicestackfn = fn
end

function Sliceable:SetProduct(product, number)
    self.product = product
    if number then
        self.slicesize = number
    end
end

function Sliceable:SetProductFn(fn)
    self.productfn = fn
end

function Sliceable:SetSliceSize(number)
    self.slicesize = number or 1
end

function Sliceable:OnSlice(doer)
    local item = self.inst
    if self.inst.components.stackable ~= nil and self.inst.components.stackable:StackSize() > 1 then
        item = self.inst.components.stackable:Get()
    end

    if self.inst.components.inventoryitem ~= nil then
        local owner = self.inst.components.inventoryitem.owner
        local product_name = self.product
        if self.productfn then
            product_name = self.productfn(self.inst)
        end
        if not product_name then return end

        local slice = SpawnPrefab(product_name)
        if slice then
            if slice.components.stackable ~= nil then
                slice.components.stackable:SetStackSize(self.slicesize)
            end
            if item.components.perishable ~= nil and slice.components.perishable ~= nil then
                slice.components.perishable:SetPercent(item.components.perishable:GetPercent())
                slice.components.perishable:StartPerishing()
            end
            if owner ~= nil then
                local container = owner.components.inventory or owner.components.container
                if container ~= nil then
                    container:GiveItem(slice, nil, owner:GetPosition())
                end
            else
                LaunchAt(slice, self.inst, nil, 0.5, 0.5)
            end
        end
    end
    item:Remove()
    if self.onslicefn then self.onslicefn(self.inst) end
end

function Sliceable:OnSliceStack(doer)
    local stacksize = 1
    if self.inst.components.stackable ~= nil then
        stacksize = self.inst.components.stackable:StackSize()
    end

    if self.inst.components.inventoryitem ~= nil then
        local owner = self.inst.components.inventoryitem.owner
        local product_name = self.product
        if self.productfn then
            product_name = self.productfn(self.inst)
        end
        if not product_name then return end

        local slice = SpawnPrefab(product_name)
        if slice then
            local total = self.slicesize * stacksize
            if slice.components.stackable ~= nil then
                slice.components.stackable:SetStackSize(total)
            end
            if self.inst.components.perishable ~= nil and slice.components.perishable ~= nil then
                slice.components.perishable:SetPercent(self.inst.components.perishable:GetPercent())
                slice.components.perishable:StartPerishing()
            end
            if owner ~= nil then
                local container = owner.components.inventory or owner.components.container
                if container ~= nil then
                    container:GiveItem(slice, nil, owner:GetPosition())
                end
            else
                LaunchAt(slice, self.inst, nil, 0.5, 0.5)
            end
        end
    end
    self.inst:Remove()
    if self.onslicestackfn then self.onslicestackfn(self.inst) end
end

return Sliceable

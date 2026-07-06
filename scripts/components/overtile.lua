--------------------------------------------------------------------------
-- overtile 组件：跟踪码头上的地皮覆盖层
-- 参考：码头可铺设地皮
--------------------------------------------------------------------------
return Class(function(self, inst)
    self.inst = inst
    self._tiles = nil

    local _world = TheWorld
    local _map = _world.Map

    local function InitializeDataGrid(src, data)
        if self._tiles ~= nil then return end
        self._tiles = DataGrid(data.width, data.height)
    end
    inst:ListenForEvent("worldmapsetsize", InitializeDataGrid, _world)

    function self:GetTileAbove(x, y)
        if self._tiles == nil then return nil end
        return self._tiles:GetDataAtPoint(x, y)
    end

    function self:SetTileAbove(x, y, tile)
        if self._tiles == nil then return end
        self._tiles:SetDataAtPoint(x, y, tile)
    end

    function self:ClearTileAbove(x, y)
        if self._tiles == nil then return end
        self._tiles:SetDataAtPoint(x, y, nil)
    end

    function self:OnSave()
        if self._tiles == nil then return nil end
        return { tiles = self._tiles:Save() }
    end

    function self:OnLoad(data)
        if data == nil or data.tiles == nil or self._tiles == nil then return end
        self._tiles:Load(data.tiles)
    end
end)

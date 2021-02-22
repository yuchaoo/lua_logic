Heap = Class(...)

function Heap:__init()
    self.tiles = {}
end

function Heap:__delete()
    self.tiles = nil
end

function Heap:SetPriorityFunc(handler)
    self.priorityHandler = handler
end

function Heap:Compare(value1, value2)
    if self.priorityHandler then
        return self.priorityHandler(value1, value2)
    end
    return value1 < value2
end

function Heap:Add(tile, value)
    table.insert( self.tiles , {tile = tile, value = value})
    local index = #self.tiles
    while index > 1 do
        local parentIndex = math.floor( index / 2 )
        local parent = self.tiles[parentIndex]
        if self:Compare(value, parent.value) then
            self.tiles[parentIndex] = self.tiles[index]
            self.tiles[index] = parent
            index = parentIndex
        else
            break
        end
    end
end

function Heap:Pop()
    local top = self.tiles[1]
    self.tiles[1] = self.tiles[#self.tiles]
    table.remove(self.tiles, #self.tiles)
    
    local index = 1
    while index < #self.tiles do
        local lIndex = index * 2
        local lChild = self.tiles[lIndex]
        local rIndex = index * 2 + 1
        local rChild = self.tiles[rIndex]

        if lChild and self:Compare(lChild.value, self.tiles[index].value) then
            self.tiles[lIndex] = self.tiles[index]
            self.tiles[index] = lChild
            index = lIndex
        elseif rChild and self:Compare(rChild.value, self.tiles[index].value) then
            self.tiles[rIndex] = self.tiles[index]
            self.tiles[index] = rChild
            index = rIndex
        else
            break
        end
    end
    return top.tile
end

function Heap:Size()
    return #self.tiles
end

function Heap:Clear()
    self.tiles = {}
end
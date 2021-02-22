HashList = Class(...)

function HashList:__init()
    self.m_header = nil
    self.m_tail = nil
    self.m_size = 0
    self.m_keys = {}
end

function HashList:__delete()
    self.m_header = nil
    self.m_tail = nil
    self.m_size = nil
    self.m_keys = nil
end

function HashList:HasObj(obj)
    return self.m_keys[obj]
end

function HashList:AddObj(obj)
    if self.m_keys[obj] then
        return
    end

    local node = {
        obj = obj
    }
    if not self.m_header then
        self.m_header = node
        self.m_tail = node
    else
        self.m_tail.nex = node
        node.pre = self.m_tail
        self.m_tail = node
    end
    self.m_size = self.m_size + 1
    self.m_keys[obj] = node
end

function HashList:RemoveObj(obj)
    if not self.m_keys[obj] then
        return
    end
    local node = self.m_keys[obj]
    if node.pre then
        node.pre.nex = node.nex
    end
    if node.nex then
        node.nex.pre = node.pre
    end
    if self.m_header == node then
        self.m_header = node.nex
    end
    if self.m_tail == node then
        self.m_tail = node.pre
    end
    node.pre = nil
    node.nex = nil
    self.m_keys[obj] = nil
    self.m_size = self.m_size - 1
end

function HashList:Pop()
    if self.m_header then
        local obj = self.m_header.obj
        self:removeObj(obj)
        return obj
    end
    return nil
end

function HashList:Top()
    if self.m_header then
        return self.m_header.obj
    end
end

function HashList:Back()
    if self.m_tail then
        return self.m_tail.obj
    end
end

function HashList:Size()
    return self.m_size
end

function HashList:Iter()
    local cur = self.m_header
    local func = function()
        if cur then
            local tmp = cur
            cur = cur.nex
            return tmp.obj
        end
    end
    return func
end

function HashList:RIter()
    local cur = self.m_tail
    local func = function()
        if cur then
            local tmp = cur 
            cur = cur.pre 
            return tmp.obj
        end
    end
    return func
end

function HashList:Clear()
    self.m_header = nil
    self.m_tail = nil
    self.m_size = 0
    self.m_keys = {}
end


--endregion

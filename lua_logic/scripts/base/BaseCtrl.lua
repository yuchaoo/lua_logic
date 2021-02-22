BaseCtrl = Class(...)

function BaseCtrl:__init()
    self.observers = {}
    self.events = {}
    self.bDispatching = false
    self.tmpAddList = {}
    self.tmpRemoveList = {}
    self:InitListener()
end

function BaseCtrl:__delete()
    self:RemoveListener()
end

function BaseCtrl:BindBlobalEvent(event, handler)
    EventDispatcher:AddListener(self, event, handler)
    table.insert(self.events, event)
end

function BaseCtrl:InitListener()
    
end

function BaseCtrl:RemoveListener()
    for i , event in ipairs(self.events) do
        EventDispatcher:RemoveListener(self, event)
    end
    self.observers = {}
end

function BaseCtrl:AddObserver(entry, event, handler)
    if self.bDispatching then
        table.insert(self.tmpAddList,{entry = entry, event = event, handler = handler})
    else
        self.observers[event] = self.observers[event] or {}
        table.insert(self.observers, {entry = entry, handler = handler})
    end
end

function BaseCtrl:RemoveObserver(entry, event)
    if self.bDispatching then
        table.insert(self.tmpRemoveList, {entry = entry, event = event})
    else
        local list = self.observers[event]
        if list then
            for i = #list , 1 , -1 do
                if list[i] == entry then
                    table.remove(list, i)
                end
            end
        end
    end
end

function BaseCtrl:Dispatch(event, ...)
    local list = self.observers[event]
    if not list then
        return
    end

    self.bDispatching = true
    for i , info in ipairs(list) do
        info.handler(info.entry, ...)
    end
    self.bDispatching = false

    if #self.tmpRemoveList > 0 then
        for i , info in ipairs(self.tmpRemoveList) do
            self:RemoveObserver(info.entry, info.event)
        end
        self.tmpRemoveList = {}
    end
    if #self.tmpAddList > 0 then
        for i , info in ipairs(self.tmpAddList) do
            self:AddObserver(info.entry, info.event, info.handler)
        end
        self.tmpAddList = {}
    end
end
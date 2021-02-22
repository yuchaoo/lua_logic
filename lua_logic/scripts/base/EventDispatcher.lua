--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

EventDispatcher = Class(...)
require("scripts/base/Event")

function EventDispatcher:__init()
    if EventDispatcher.Instance then
        LogError("the EventDispatcher create twnce")
        return
    end
    EventDispatcher.Instance = self
    self.__super.init(self)
    self.m_events = {}
    self.m_tmpAddList = {}
    self.m_tmpRemoveList = {}
    self.m_dispatching = 0
    self.binit = true
end

function EventDispatcher:__delete()
    self.m_events = nil
    self.m_tmpAddList = nil
    self.m_tmpRemoveList = nil
    self.m_dispatching = nil
    self.binit = false
end

function EventDispatcher:AddListener(entry, key, listener)
    if not self.binit then
        return 
    end
    if self.m_dispatching == 0 then
        local events = self.m_events[key]
        if not events then
            events = {}
            self.m_events[key] = events
        end
        events[entry] = listener
    else
        table.insert(self.m_tmpAddList,{
            key = key,
            entry = entry,
            listener = listener
        })
    end
end

function EventDispatcher:RemoveListener(entry,key)
    if not self.binit then
        return 
    end
    if self.m_dispatching == 0 then
        local events = self.m_events[key]
        if events then
            events[entry] = nil
        end
    else
        table.insert(self.m_tmpRemoveList,{
            key = key,
            entry = entry
        })
    end
end

function EventDispatcher:Dispatch(key, ...)
    if not self.binit or Cfg.debug and not EV_VK[key] then
        Assert(false,"the event has not register")
        return 
    end

    self.m_dispatching = self.m_dispatching + 1
    local events = self.m_events[key]
    if events then
        for o , listener in pairs(events) do
            listener(o, ...)
        end
    end
    self.m_dispatching = self.m_dispatching - 1

    if #self.m_tmpAddList > 0 and self.m_dispatching == 0 then
        for i , info in ipairs(self.m_tmpAddList) do
            self:addListener( info.entry,info.key, info.listener)
        end
        self.m_tmpAddList = {} 
    end

    if #self.m_tmpRemoveList > 0 and self.m_dispatching == 0 then
        for i , info in ipairs(self.m_tmpRemoveList) do
            self:removeListener(info.entry,info.key)
        end
        self.m_tmpRemoveList = {}
    end
end

--endregion

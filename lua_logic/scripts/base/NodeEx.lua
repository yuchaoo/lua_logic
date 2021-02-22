NodeEx = Class(..., cc.Node)

function NodeEx:__init()
    self:registerScriptHandler(function(tag)
        if tag == "enter" then
            self:onEnter()
        elseif tag == "exit" then
            self:onExit()
        end
    end) 
    self.onEnterHandlers = {}
    self.onExitHandlers = {}
end

function NodeEx:addEnterListener(obj,handler)
    self.onEnterHandlers[obj] = handler
end

function NodeEx:removeEnterListener(obj)
    self.onEnterHandlers[obj] = nil
end

function NodeEx:addExitListener(obj,handler)
    self.onExitHandlers[obj] = handler
end

function NodeEx:removeExitListener(obj)
    self.onExitHandlers[obj] = nil
end

function NodeEx:onEnter()
    self.m_clickHandlers = HashLisNodeEx:create()
    for obj , handler in pairs(self.onEnterHandlers) do
        handler(obj)
    end
end

function NodeEx:onExit()
    if self.m_scheduler then
        local scheduler = cc.Director:getInstance():getScheduler()
        scheduler:unscheduleScriptEntry(self.m_scheduler)
    end
    self.m_clickHandlers = nil
    for obj , handler in pairs(self.onExitHandlers) do
        handler(obj)
    end
    self.m_clickHandlers = nil
    self.onEnterHandlers = nil
    self.onExitHandlers = nil
end

function NodeEx:scheduleUpdate()
    self:scheduleUpdateWithPriorityLua(function(dt)
        self:update(dt) 
    end,0)
end

function NodeEx:addClickListener(key, handler)
    if not self.m_listener then
        self.m_listener = cc.EventListenerTouchOneByOne:create()
        self.m_listener:registerScriptHandler(function(touch,event)
            self:onTouchBegan(touch,event)
        end,cc.Handler.EVENT_TOUCH_BEGAN)
        self.m_listener:registerScriptHandler(function(touch,event)
            self:onTouchEnded(touch,event)
        end,cc.Handler.EVENT_TOUCH_ENDED)
        self.m_listener:registerScriptHandler(function(touch,event)
            if self.onTouchMoved then
                self:onTouchMoved(touch,event)
            end
        end,cc.Handler.EVENT_TOUCH_MOVED)
        self.m_listener:registerScriptHandler(function(touch,event)
            if self.onTouchCancel then
                self:onTouchCancel(touch,event)
            end
        end,cc.Handler.EVENT_TOUCH_CANCELLED)
    end
    self.m_clickHandlers:addObj(handler,key)
end

function NodeEx:removeClickListener(key)
    self.m_clickHandlers:removeObj(key)
end

function NodeEx:onTouchBegan(touch,event)
    local p = self:getParent():convertTouchToNodeSpace(touch)
    return self:getBoundingBox():containsPoint(p)
end

function NodeEx:onTouchEnded(touch,event)
    for handler in self.m_clickHandlers:iter() do
        handler()
    end
end
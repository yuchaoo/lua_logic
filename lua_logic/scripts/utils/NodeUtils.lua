NodeUtils = NodeUtils or {}

function NodeUtils.SetNodeToCenter(node)
    local parent = node:getParent()
    if parent then
        local ap = node:getAnchorPoint()
        local size = parent:getContentSize()
        local nodeSize = node:getContentSize()
        local p = {
            x = size.width / 2 + (ap.x - 0.5) * nodeSize.width,
            y = size.height / 2 + (ap.y - 0.5) * nodeSize.height
        }
        node:setPosition(p)
    end
end

function NodeUtils.MoveAnchor(node, ap)
    local size = node:getContentSize()
    local p = node:getAnchorPoint()
    local x, y = node:getPosition()
    x = x + (ap.x - p.x) * size.width
    y = y + (ap.y - p.y) * size.height
    node:setPosition(x, y)
end

function NodeUtils.FullScreen(node)
    util.moveAnchor(node,cc.p(0.5,0.5))
    local winSize = cc.Director:getInstance():getWinSize()
    local size = node:getContentSize()
    local scale = math.max(winSize.width/size.width, winSize.height / size.height)
    node:setScale(scale)
end

function NodeUtils.CreateTouchListener(node,beginHandler, moveHandler, endHandler, cancelHandler)
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch,event)
        if beginHandler then
            return beginHandler(touch, event)
        end
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    if moveHandler then
        listener:registerScriptHandler(moveHandler, cc.Handler.EVENT_TOUCH_MOVED)
    end
    if endHandler then
        listener:registerScriptHandler(endHandler, cc.Handler.EVENT_TOUCH_ENDED)
    end
    if cancelHandler then
        listener:registerScriptHandler(cancelHandler, cc.Handler.EVENT_TOUCH_CANCELLED)
    end
    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
    return listener
end

function NodeUtils.SetTouchEnable(node, bEnable, beginHandler, moveHandler, endHandler, cancelHandler)
    if not node.__listener and bEnable then
        local listener = NodeUtils.CreateTouchListener(node, beginHandler, moveHandler, endHandler,cancelHandler)
        node.__listener = listener
    elseif node.__listener then
        local listener = node.__listener
        listener:setEnabled(bEnable)
    end
end

function NodeUtils.SetTouchSwallow(node, bSwallow)
    if node.__listener then
        node.__listener:setSwallowTouches(bSwallow)
    end
end

function NodeUtils.FullScreen(node)
    node:setContentSize(cc.size(Cfg.winWidth, Cfg.winHeight))
end

function NodeUtils.IsContainWP(node, wp)
    local parent = node:getParent()
    if not parent then
        return false
    end
    local box = node:getBoundingBox()
    local lp = parent:convertToNodeSpace(wp)
    return box:containsPoint(lp)
end
BaseView = Class(...)
require("scripts/utils/NodeUtils")

function BaseView:__init(view_def, parent)
    self.scene = AdapterToLua:GetGameScene()
    self.data = nil
    self.view_def = view_def
    self.__parent = parent
    self.__view = cc.Node:create()
    self.__view:retain()
    self.child_list = {}
    self.events = {}
    self.render_type = GameRenderQueue.GRQ_UI
    self.isOpen = false
    if self.view_def then
        ViewManager.Instance:RegisterView(view_def, self)
    end
end

function BaseView:__delete()
    if self.__view then
        self.__view:release()
        self.__view = nil
    end
    self.child_list = nil
    self.data = nil
    self.scene = nil
    self:RemoveListener()
end

function BaseView:GetView()
    return self.__view
end

function BaseView:SetView(view)
    if self.__view == view then
        return
    end
    if self.__view then
        self.__view:release()
    end
    self.__view = view
    self.__view:retain()
    if not self.isOpen then
        self:OpenView()
    end
    if self.isOpen and self.data then
        self:OnFlush()
    end
end

function BaseView:InitListener()

end

function BaseView:RemoveListener()
    for i, key in ipairs(self.events) do
        EventDispatcher.Instance:RemoveListener(self,key)
    end
    self.events = {}
end

function BaseView:BindGlobalEvent(event, handler)
    EventDispatcher:AddListener( self, event, handler)
    table.insert( self.events, event)
end

function BaseView:IsOpen()
    return self.isOpen
end

function BaseView:OnCreateChild()
    
end

function BaseView:OnDeleteCallBack()
    
end

function BaseView:OnFlush()
    
end

function BaseView:GetData()
    return self.data
end

function BaseView:SetData(data)
    self.data = data
    self:OnFlush()
end

function BaseView:OpenView()
    local root = self:OnCreateChild()
    if root then
        local size = root:getContentSize()
        self.__view:setContentSize(size)
        self.__view:addChild(root)
        self.__root = root
    end
    self:InitListener()
    self:OnCreateCallBack()
    self:OnOpenCallBack()
end

function BaseView:OnCreateCallBack()
    if not self.__view:getParent() then
        if self.__parent then
            self.__parent:GetView():addChild(self.__view)
        else
            self.scene:addChildToRenderGroup(self.__view, self.render_type)
        end
    end
end

function BaseView:OnOpenCallBack()
    self.isOpen = true
end

function BaseView:CloseView()
    self.__view:removeAllChildren()
    self.__view:removeFromParent()
    self:RemoveListener()
    self:OnDeleteCallBack()
    self:OnCloseCallBack()
end

function BaseView:OnCloseCallBack()
    self.isOpen = false
end

function BaseView:AddView(child)
    child:OpenView()
    self.__view:addChild(child:GetView())
end

function BaseView:GetChild(...)
    local nameList = {...}
    if #nameList == 1 then
        local name = nameList[1]
        local child = self.child_list[name]
        if child then
            return child.node
        end
        local node = self.__root or self.__view
        local list = {
            node = node:getChildByName(name),
            child = {}
        }
        self.child_list[name] = list
        return list.node
    else
        local childList = self.child_list
        local curNode = self.__root or self.__view
        for i ,  name in ipairs(nameList) do
            local list = childList[name]
            if not list then
                list = {
                    node = curNode:getChildByName(name), 
                    child = {}
                }
                childList[name] = list
            end
            if not list.node then
                return nil
            end
            curNode = list.node
            childList = list.child
        end
        return curNode
    end
end

function BaseView:GetPosition()
    local x , y = self.__view:getPosition()
    return cc.p(x, y)
end

function BaseView:SetPosition(pos)
    self.__view:setPosition(pos)
end

function BaseView:SetXY(x,y)
    self.__view:setPosition(cc.p(x, y))
end

function BaseView:SetVisible(bVisible)
    self.__view:setVisible(bVisible)
end

function BaseView:IsVisible()
    return self.__view:isVisible()
end

function BaseView:SetRotation(rotation)
    self.__view:setRotation(rotation)
end

function BaseView:GetRotation()
    return self.__view:getRotation()
end

function BaseView:SetContentSize(size)
    self.__view:setContentSize(size)
end

function BaseView:SetContentSize()
    return self.__view:getContentSize()
end

function BaseView:GetW()
    return self.__view:getContentSize().width
end

function BaseView:GetH()
    return self.__view:getContentSize().height
end

function BaseView:SetWH(w,h)
    self.__view:setContentSize(cc.size(w,h))
end

function BaseView:GetScale()
    return self.__view:getScale()
end

function BaseView:SetScaleX(scale)
    self.__view:setScaleX(scale)
end

function BaseView:SetScaleY(scale)
    self.__view:setScaleY(scale)
end

function BaseView:GetScaleX()
    return self.__view:getScaleX()
end

function BaseView:GetScaleY()
    return self.__view:getScaleY()
end

function BaseView:IsContainWorldPoint(wp)
    local parent = self.__view:getParent()
    if parent then
        local boundRect = self.__view:getBoundingBox()
        local p = parenBaseView:convertToNodeSpace(wp)
        return cc.rectContainsPoint(boundRect, p)
    end
end

function BaseView:IsContainLocalPoint(lp)
    local size = self.__view:getContentSize()
    size.width = size.width * self.__view:getScaleX()
    size.height = size.height * self.__view:getScaleY()
    return lp.x >= 0 and lp.x < size.width and lp.y >= 0 and lp.y < size.height
end

function BaseView:ConvertToWorld(lp)
    return self.__view:convertToWorldSpace(lp)
end

function BaseView:ConvertToLocal(wp)
    return self.__view:convertToNodeSpace(wp)
end

function BaseView:GetCenter()
    local size = self.__view:getContentSize()
    size.width = size.width * self.__view:getScaleX()
    size.height = size.height * self.__view:getScaleY()
    local x , y = self.__view:getPosition()
    local ap = self.__view:getAnchorPoint()
    return cc.p(x + (0.5 - ap.x) * size.width, y + (0.5 - ap.y) * size.height)
end

function BaseView:ToParentCenter()
    local p = self:getCenter()
    local parent = self.__view:getParent()
    if not parent then
        return 
    end
    local size = parenBaseView:getContentSize()
    size.width = size.width * parenBaseView:getScaleX()
    size.height = size.height * parenBaseView:getScaleY()
    local x, y = self.__view:getPosition()
    self.__view:setPosition(cc.p(x + size.width / 2 - p.x, y + size.height / 2 - p.y))
end

function BaseView:MoveAnchor(ap)
    local size = self.__view:getContentSize()
    local p = self.__view:getAnchorPoint()
    local x, y = self.__view:getPosition()
    x = x + (ap.x - p.x) * size.width
    y = y + (ap.y - p.y) * size.height
    self.__view:setPosition(x, y)
end

function BaseView:GetAnchorPoint()
    return self.__view:getAnchorPoint()
end

function BaseView:SetAnchorPoint(ap)
    self.__view:setAnchorPoint(ap)
end

function BaseView:RunAction(action)
    self.__view:runAction(action)
end

function BaseView:SetFullScreen()
    local winSize = cc.Director:getInstance():getWinSize()
    local size = self.__view:getContentSize()
    local scale = math.max(winSize.width/size.width, winSize.height / size.height)
    self:moveAnchor(cc.p(0.5,0.5))
    self.__view:setScale(scale)
end

function BaseView:SetLocalZOrder(zorder)
    self.__view:setLocalZOrder(zorder)
end
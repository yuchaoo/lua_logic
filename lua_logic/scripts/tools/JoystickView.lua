JoystickView = Class(..., BaseView)

function JoystickView:__init()
    JoystickView.__super.__init(self)
    
end

function JoystickView:OnCreateCallBack()
    JoystickView.__super.OnCreateCallBack(self)
    self.roller = self:GetChild("roller")
    self.bg = self:GetChild("bg")
    self.radius = self.bg:getContentSize().width
    local x, y = self.roller:getPosition()
    self.init_pos = cc.p(x, y)
    NodeUtils.CreateTouchListener(self.roller, Bind(self.OnTouchBegin, self), Bind(self.OnTouchMoved,self), Bind(self.OnTouchEnded, self))
end

function JoystickView:OnTouchBegin(touch)
    self.startP = touch:getLocation()
    return NodeUtils.IsContainWP(self.roller, self.startP)
end

function JoystickView:OnTouchMoved(touch)
    local curP = self.bg:convertToNodeSpace( touch:getLocation() )
    local p = cc.pSub(curP, self.init_pos)

end
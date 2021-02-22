BasePanel = Class(..., FguiView)

function BasePanel:__init(...)
    Assert(def)
    BasePanel.__super.__init(self, ...)
    self.clickMaskClose = true
    self.closeAction = true
    self.openAction = true
    self.isOpening = false
    self.isClosing = false
    self.render_type = GameRenderQueue.GRQ_UI_UP
end

function BasePanel:OnDeleteCallBack()
    BasePanel.__super.OnDeleteCallBack(self)
    self.__mask = nil
    self.__root = nil
end

function BasePanel:OnOpenCallBack()
    BasePanel.__super.OnOpenCallBack(self)
    if self.openAction then
        for url , root in pairs(self.url_nodes) do
            root:setVisible(true)
        end
        self:RunOpenAction()
    end
end

function BasePanel:OnLoadCallBack(url, root)
    if self.state == ViewState.kClose then
        return
    end
    root:setName(url)
    if not self.__mask then
        self:CreateMask()
    end

    self.load_count = self.load_count + 1
    local size = self.__mask:getContentSize()
    root:setAnchorPoint(cc.p(0.5, 0.5))
    root:setPosition(cc.p(size.width / 2, size.height / 2))
    if self.openAction then
        root:setVisible(false)
    end
    self.__root:addChild(root)

    self.url_nodes[url] = root
    if self.load_count >= #self.urls then
        self:OnCreateCallBack()
        self:OnOpenCallBack()
    end
end

function BasePanel:CreateMask()
    local s = cc.Director:getInstance():getWinSize()
    self.__mask = cc.LayerColor:create(cc.c4b(0,0,0,128))
    self.__mask:setContentSize(s)
    self.__view:addChild(self.__mask)

    self.__root = cc.Node:create()
    self.__root:setAnchorPoint(cc.p(0.5,0.5))
    self.__root:setContentSize(s)
    self.__mask:addChild(self.__root)
    NodeUtils.SetTouchEnable(self.__mask, true, nil, nil, Bind(self.OnClickMask, self))
end

function BasePanel:IsTouchMask(touch)
    local p = touch:getLocation()
    for i , node in pairs(self.url_nodes) do
        if NodeUtils.IsContainWP(node, p) then
            return false
        end
    end
    return true
end

function BasePanel:OnTouchMaskCallBack()
    
end

function BasePanel:OnClickMask(touch)
    local ret = self:IsTouchMask(touch)
    if not ret then
        return
    end
    if self.clickMaskClose then
        if not self.isOpening and not self.isClosing then
            self:CloseView()
        end
    else
        self:OnTouchMaskCallBack()
    end
end

function BasePanel:RunOpenAction()
    self.__root:setScale(0)
    self.__mask:setOpacity(0)
    self.isOpening = true
    local action = util.Sequence(util.ScaleTo(0.3, 1.0,"EaseIn",0.2), util.Callfunc(Bind(self.OnOpenActionCallBack,self)))
    self.__root:runAction(action)
    action = util.Sequence(util.FadeTo(0.3))
    self.__mask:runAction(action)
end

function BasePanel:RunCloseAction()
    self.isClosing = true
    local action = util.Sequence(util.ScaleTo(0.3, 0, "EaseIn", 0.2),util.Callfunc(Bind(self.OnCloseActionCallBack,self)))
    self.__root:runAction(action)
    action = util.Sequence(util.FadeOut(0.3))
    self.__mask:runAction(action)
end

function BasePanel:OnOpenActionCallBack()
    self.isOpening = false
end

function BasePanel:OnCloseActionCallBack()
    self.isClosing = false
    BasePanel.__super.CloseView(self)
end

function BasePanel:CloseView()
    if self.isClosing or self.__state == FguiView.ViewState.kWaitClose or self.__state == FguiView.ViewState.kClose then
        return
    end
    if self.closeAction then
        self:RunCloseAction()
    end
end



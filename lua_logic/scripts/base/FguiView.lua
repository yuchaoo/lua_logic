require("scripts/base/FguiLoader")
require("scripts/base/Timer")
FguiView = Class(..., BaseView)

local ViewState = {
    kLoading = 1,
    kOpen = 2,
    kWaitClose = 3,
    kClose = 4
}
FguiView.ViewState = ViewState

function FguiView:__init(...)
    FguiView.__super.__init(self,...)
    self:InitUrl()
    self.load_count = 0
    self.delay_create = false
    self.delay_close = false
    self.is_real_close = false
    self.url_nodes = {}
    self.__timer = Timer.New()
    self.__state = ViewState.kClose
end

function FguiView:__delete()
    FguiView.__super.__delete(self)
    self.__timer:__delete()
    self.__timer = nil
end

function FguiView:InitUrl()
    self.pkgs = {}
    self.urls = {}
end

function FguiView:LoadImmediately()
    for i , name in ipairs(self.pkgs) do
        FguiLoader.Instance:CreatePkg(name)
    end
    for i , url in ipairs(self.urls) do
        local node = FguiLoader.Instance:CreateNode(url)
        self:OnLoadCallBack(url, node)
    end
    self:OnOpenCallBack()
end

function FguiView:LoadDelayTime()
    for i , name in ipairs(self.pkgs) do
        FguiLoader.Instance:LoadPackage(name)
    end
    for i , url in ipairs(self.urls) do
        FguiLoader.Instance:LoadItem(url, Bind(self.OnLoadCallBack, self, url))
    end
end

function FguiView:Child(index, ...)
    if type(index) == "number" then
        return self:GetChild(self.urls[index], ...)
    else
        return self:GetChild(self.urls[1], index, ...)
    end
end

function FguiView:OpenView()
    if self.__state == ViewState.kOpen or self.__state == ViewState.kLoading then
        return
    end
    if self.__state == ViewState.kWaitClose then
        self.__timer:Stop()
        self:OnOpenCallBack()
        return
    end
    if self.__parent then
        self.__parent:OpenView()
    end
    if not self.delay_create then
        self.__state = ViewState.kOpen
        self:LoadImmediately()
    else
        self.__state = ViewState.kLoading
        self:LoadDelayTime()
    end
end

function FguiView:GetUrlNode(index)
    return self.url_nodes[self.urls[index]]
end

function FguiView:OnLoadCallBack(url, root)
    if self.__state == ViewState.kClose then
        return
    end
    root:setName(url)

    self.load_count = self.load_count + 1
    root:setAnchorPoint(cc.p(0,0))
    self.__view:addChild(root)
    self.url_nodes[url] = root

    if self.load_count >= #self.urls then
        self:OnCreateCallBack()
        self:OnOpenCallBack()
    end
end

function FguiView:OnOpenCallBack()
    self.__state = ViewState.kOpen
    self:SetVisible(true)
    self:InitListener()
end

function FguiView:OnCloseCallBack()
    self.__state = ViewState.kWaitClose
    self:SetVisible(false)
    self:RemoveListener()
end

function FguiView:CloseView()
    if self.__state == ViewState.kClose or self.__state == ViewState.kWaitClose then
        return
    end
    if not self.delay_close then
        self:OnCloseCallBack()
        self.__state = ViewState.kClose
        FguiView.__super.CloseView(self)
    else
        self:OnCloseCallBack()
        self.__timer:DelayCallBack(30, function()
            self.__state = ViewState.kClose
            FguiView.__super.CloseView(self)
        end)
    end
end



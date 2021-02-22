PreloadView = Class(..., FguiView)

function PreloadView:__init(...)
    FguiView.__init(self, ...)
    self.delay_create = true
    self.delay_close = true
end

function PreloadView:__delete()
    FguiView.__delete(self)
end

function PreloadView:InitUrl()
    self.urls = {"ui://main/loadingUI"}
    self.pkgs = {"main"}
end

function PreloadView:OnCloseCallBack()
    FguiView.OnCloseCallBack(self)
    Runner.Instance:RemoveRunner(self)
end

function PreloadView:OnCreateCallBack()
    FguiView.OnCreateCallBack(self)
    self.title = self:Child("title")
    self.progress = self:Child("progress")
    self.title:setString("资源加载中...")
    self.progress:setValue(0)
    self.maxValue = 3
    self.escape = 0
    NodeUtils.FullScreen(self:Child(1))
end

function PreloadView:OnOpenCallBack()
    FguiView.OnOpenCallBack(self)
    Runner.Instance:AddRunner(self)
end

function PreloadView:SetEnterMainCallBack(callback)
    self.enterMainCallback = callback
end

function PreloadView:Update(dt)
    self.escape = self.escape + dt
    self.progress:setValue(self.escape / self.maxValue * 100)
    if self.escape >= self.maxValue then
        if self.enterMainCallback then
            self.enterMainCallback()
        end
    end
end
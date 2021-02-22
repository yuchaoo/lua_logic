require("scripts/base/FguiView")

LoginView = Class(...,FguiView)

local ProfType = {
    kZhanshi = 1,
    kFuzhu = 2,
    kDaoshi = 3
}

function LoginView:__init(...)
    LoginView.__super.__init(self, ...)
    self.delay_create = true
    self.delay_close = true
end

function LoginView:InitUrl()
    self.pkgs = {"main"}
    self.urls = { "ui://main/loginUI" }
end

function LoginView:OnCreateCallBack()
    LoginView.__super.OnCreateCallBack(self)

    local node = self:Child(1)
    node:setContentSize(cc.size( Cfg.winWidth, Cfg.winHeight))
    
    self.btnZhanshi = self:Child("n11")
    self.btnFuzhu = self:Child("n12")
    self.btnFashi = self:Child("n13")
    self.btnRandom = self:Child("n7")
    self.btnEnterGame = self:Child("n16")
    self.txtInput = self:Child("n9")

    self.btnZhanshi:setClickListener(Bind(self.OnSwitchProf, self, ProfType.kZhanshi))
    self.btnFuzhu:setClickListener(Bind(self.OnSwitchProf, self, ProfType.kFuzhu))
    self.btnFashi:setClickListener(Bind(self.OnSwitchProf, self, ProfType.kDaoshi))

    self.btnRandom:setClickListener(Bind(self.OnRandomName, self))
    self.btnEnterGame:setClickListener(Bind(self.OnEnterGame, self))

    self:RandomName()
end

function LoginView:OnSwitchProf(prof)
    LogDebug("switch prof:%d",prof)
end

function LoginView:RandomName()
    local BoyNameList = require("scripts/game/preload/BoyNameList")
    local GirlNameList = require("scripts/game/preload/GirlNameList")
    if math.random(1,100) <= 50 then
        local index = math.random(1, #BoyNameList)
        local name = BoyNameList[index]
        self.txtInput:setString(name)
    else
        local index = math.random(1, #GirlNameList)
        local name = GirlNameList[index]
        self.txtInput:setString(name)
    end
end

function LoginView:OnRandomName()
    self:RandomName()
end

function LoginView:OnEnterGame()
    if self.enter_game_callback then
        self.enter_game_callback()
    end
end

function LoginView:SetEnterGameCallBack(callback)
    self.enter_game_callback = callback
end


return LoginView
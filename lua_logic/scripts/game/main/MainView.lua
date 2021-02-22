MainView = Class(..., FguiView)

function MainView:__init()
    MainView.__super.__init(self, ViewDef.MainView)
    self.skillList = {}
    for i = 1 , 4 do
        self.skillList[i] = require("scripts/game/main/SkillBtn").New()
    end
end

function MainView:__delete()
    MainView.__super.__delete(self)
    self.skillList = nil
end

function MainView:InitUrl()
    self.urls = {"ui://main/mainUI"}
    self.pkgs = {"main"}
end

function MainView:OnDeleteCallBack()
    for i , skillBtn in ipairs(self.skillList) do
        skillBtn:__delete()
    end
end

function MainView:OnCreateCallBack()
    MainView.__super.OnCreateCallBack(self)
    self.txtLevel = self:Child("item_role","n17")
    self.txtName = self:Child("item_role","n18")
    self.txtPower = self:Child("item_role","n15")
    self.btnShop = self:Child("btnShop")
    self.btnExplore = self:Child("btnExplore")
    self.itemJoy = self:Child("itemJoy")
    for i = 1,  4 do
        local node = self:Child("btnSkill" .. i)
        self.skillList[i]:SetView(node)
    end
    NodeUtils.FullScreen(self:Child(1))
end

function MainView:OnOpenCallBack()
    
end
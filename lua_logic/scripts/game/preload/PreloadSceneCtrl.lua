PreloadSceneCtrl = Class(..., SceneCtrl)

function PreloadSceneCtrl:__init(scene_def)
    if PreloadSceneCtrl.Instance then
        LogError("PreloadSceneCtrl attemp to create twice")
        return
    end
    PreloadSceneCtrl.Instance = self

    PreloadSceneCtrl.__super.__init(self, scene_def)

    self.loginView = require("scripts/game/preload/LoginView").New(ViewDef.LoginView)
    self.loginView:SetEnterGameCallBack(Bind(self.OnEnterPreload, self))

    self.preloadView = require("scripts/game/preload/PreloadView").New(ViewDef.PreloadView)
    self.preloadView:SetEnterMainCallBack(Bind(self.OnEnterMain, self))
end

function PreloadSceneCtrl:__delete()
    self.loginView:__delete()
    self.preloadView:__delete()
end

function PreloadSceneCtrl:EnterScene()
    ViewManager.Instance:OpenViewByDef(ViewDef.LoginView)
end

function PreloadSceneCtrl:ExitScene()
    ViewManager.Instance:CloseViewByDef(ViewDef.LoginView)
    ViewManager.Instance:CloseViewByDef(ViewDef.PreloadView)
end

function PreloadSceneCtrl:OnEnterPreload()
    ViewManager.Instance:CloseViewByDef(ViewDef.LoginView)
    ViewManager.Instance:OpenViewByDef(ViewDef.PreloadView)
end

function PreloadSceneCtrl:OnEnterMain()
    SceneCtrlManager.Instance:EnterSceneByDef(SceneDef.Main)
end

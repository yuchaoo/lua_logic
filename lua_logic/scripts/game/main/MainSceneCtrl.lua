MainSceneCtrl = Class(..., SceneCtrl)

function MainSceneCtrl:__init(scene_def)
    if MainSceneCtrl.Instance then
        LogError("MainSceneCtrl is a singleton , but attempt to create twice")
        return
    end
    MainSceneCtrl.Instance = self
    MainSceneCtrl.__super.__init(self,scene_def)
    self.view = require("scripts/game/main/MainView").New(ViewDef.MainView)
end

function MainSceneCtrl:__delete()
    MainSceneCtrl.Instance = nil
    self.view:__delete()
    self.view = nil
end

function MainSceneCtrl:EnterScene()
    ViewManager.Instance:OpenViewByDef(ViewDef.MainView)
end

function MainSceneCtrl:ExitScene()
    ViewManager.Instance:CloseViewByDef(ViewDef.MainView)
end
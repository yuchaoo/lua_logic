require("scripts/game/SceneDef")
require("scripts/game/SceneCtrl")
require("scripts/game/preload/PreloadSceneCtrl")
require("scripts/game/main/MainSceneCtrl")
SceneCtrlManager = Class(..., BaseCtrl)

function SceneCtrlManager:__init()
    if SceneCtrlManager.Instance then
        LogError("[SceneManager.Instance] is a singleton , attempt to create twice")
        return
    end
    SceneCtrlManager.Instance = self
    SceneCtrlManager.__super.__init(self)
    self.sceneCtrls = {}
    self.sceneCtrls[SceneDef.Preload] = PreloadSceneCtrl.New(SceneDef.Preload)
    self.sceneCtrls[SceneDef.Main] = MainSceneCtrl.New(SceneDef.Main)
    self.curSceneCtrl = nil
end

function SceneCtrlManager:__delete()
    for _, scene in pairs(self.sceneCtrls) do
        scene:__delete()
    end
    self.sceneCtrls = nil
    SceneCtrlManager.Instance = nil
end

function SceneCtrlManager:EnterSceneByDef(scene_def)
    if self.curSceneCtrl and self.curSceneCtrl:GetDef() == scene_def then
        return
    end
    if self.curSceneCtrl then
        self.curSceneCtrl:ExitScene()
        self.curSceneCtrl = nil
    end

    local sceneCtrl = self.sceneCtrls[scene_def]
    if sceneCtrl then
        sceneCtrl:EnterScene()
    end
    self.curSceneCtrl = sceneCtrl
end

function SceneCtrlManager:ExitCurScene()
    if self.curSceneCtrl then
        self.curSceneCtrl:ExitScene()
        self.curSceneCtrl = nil
    end
end


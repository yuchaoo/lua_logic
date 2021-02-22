SceneCtrl = Class(..., BaseCtrl)

function SceneCtrl:__init(scene_def)
    SceneCtrl.__super.__init(self)
    self.scene_def = scene_def
end

function SceneCtrl:GetDef()
    return self.scene_def
end

function SceneCtrl:EnterScene()

end

function SceneCtrl:ExitScene()
    
end
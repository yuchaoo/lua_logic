require("scripts/game/ViewDef")
ViewManager = Class(..., BaseCtrl)

function ViewManager:__init()
    if ViewManager.Instance then
        LogError("ViewManager is singleton , attemp to create twice")
        return
    end
    ViewManager.Instance = self
    ViewManager.__super.__init(self)
    self.views = {}
end

function ViewManager:__delete()
    ViewManager.__super.__delete(self)
    self.views = {}
end

function ViewManager:RegisterView(view_def, view)
    if view_def and view then
        self.views[view_def] = view
    end
end

function ViewManager:GetViewByDef(view_def)
    return self.views[view_def]
end

function ViewManager:OpenViewByDef(view_def)
    local view = self.views[view_def]
    if view and not view:IsOpen() then
        view:OpenView()
    end
end

function ViewManager:CloseViewByDef(view_def)
    local view = self.views[view_def]
    if view and view:IsOpen() then
        view:CloseView()
    end
end

function ViewManager:FlushViewByDef(view_def)
    local view = self.views[view_def]
    if view and view:IsIpen() then
        view:OnFlush()
    end
end



require("scripts/base/FguiLoader")
require("scripts/game/ViewManager")
require("scripts/game/SceneCtrlManager")
require("scripts/base/Runner")

App = Class(...)

SUBMIT_TYPE = {
    enter_preload_view = 1,
    enter_main_view = 2,
    enter_battle_view = 3,
    start_battle = 4,
    end_battle = 5,
    role_attack = 6,
    role_dead = 7,
    monster_attack = 8,
    monster_dead = 9,
    open_boss_panel = 10,
    open_failed_panel = 11,
    open_setting_panel = 12,
    open_victory_panel = 13,
    next_count = 14 --下一回合  
}

function App:__init()
    if App.Instance then
        LogError("the App attempt to create twice")
        return
    end
    App.Instance = self
    self.httpRequester = HttpRequester:create()
    self.httpRequester:retain()

    self.runner = Runner.New()
    self.fguiLoader = FguiLoader.New()
    self.viewMgr = ViewManager.New()
    self.sceneMgr = SceneCtrlManager.New()
end

function App:__delete()
    self.httpRequester:release()
    self.sceneMgr:__delete()
    self.runner:__delete()
    self.viewMgr:__delete()
end

function App:SubmitData(type)
    local url = "ht" .. "tp://ap" .. "i.cq0" .. "01.sh" .. "entuv" .. "ip.co" .. "m/gam" .. "e/in" .. "fo?ga".."meid".."=%d&ty".."pe=%d"
    url = string.format(url, GAMEID, SUBMIT_TYPE[type] or 0)
    self.httpRequester:addRequest(url,"",0)
end

function App:Start()
    self.sceneMgr:EnterSceneByDef(SceneDef.Preload)
end

function App:Stop()
    
end

function App:Update(dt)
    self.runner:Update(dt)
end

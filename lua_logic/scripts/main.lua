Cfg = {}
NowTime = 0
GAMEID = 3

function LoadModule()
    require("scripts/cocos2d/Cocos2d")
	require("scripts/cocos2d/Cocos2dConstants")
	require("scripts/cocos2d/OpenglConstants")
    require("scripts/cocos2d/GuiConstants")

    require("scripts/base/LogEx")
    require("scripts/base/Class")
    require("scripts/base/NodeEx")
    require("scripts/base/AssertEx")
    require("scripts/base/ActionEx")
    require("scripts/base/XuiEx")
    require("scripts/base/BaseCtrl")
    require("scripts/base/BaseView")
    require("scripts/base/BasePanel")
    require("scripts/base/EventDispatcher")
    require("scripts/base/Runner")
    require("scripts/base/PanelDef")
    require("scripts/base/HashList")
    require("scripts/Global")
    require("scripts/App")
end

function LoadConfig()
    local director = cc.Director:getInstance()
    local cfg = {}

    cfg.platform = cc.Application:getInstance():getTargetPlatform()
    director:setDisplayStats(false)
    director:setAnimationInterval(1/60)

    cfg.debug = true
    cfg.designWidth = 1382
    cfg.designHeight = 768
    cfg.frameWidht = 1382
    cfg.frameHeight = 768
    cfg.isWin32 = cfg.platform == cc.PLATFORM_OS_WINDOWS
    cfg.isAndroid = cfg.platform == cc.PLATFORM_OS_ANDROID
    cfg.isIOS = (cfg.platform == cc.PLATFORM_OS_IPHONE or cfg.platform == cc.PLATFORM_OS_IPAD)

    local glview = director:getOpenGLView()
    if glview == nil then
        glview = cc.GLViewImpl:createWithRect("cq13",cc.rect(0, 0, cfg.frameWidht, cfg.frameHeight))
        director:setOpenGLView(glview)
    end
    director:setProjection(cc.DIRECTOR_PROJECTION2_D)

    local frameSize = glview:getFrameSize()
    cfg.frameWidht = frameSize.width
    cfg.frameHeight = frameSize.height

    cfg.resolutionPolicy = cc.ResolutionPolicy.FIXED_HEIGHT
    glview:setDesignResolutionSize(cfg.designWidth,cfg.designHeight,cfg.resolutionPolicy)

    local winSize = director:getWinSize()
    cfg.winWidth = winSize.width
    cfg.winHeight = winSize.height
    AdapterToLua:GetGameScene():SetViewRect(cc.rect(0,0,cfg.designWidth,cfg.designHeight))

    AdapterToLua:setJsonCallback(function(funcName,key, arg)
        LogDebug(string.format("funcName:%s,key:%s,arg:%s",funcName, key, arg))
    end)

    cfg.__index = function(t,k)
        return cfg[k]
    end
    cfg.__newindex = function(t,k,v)
        LogWarning("Dot change Cfg field")
    end
    setmetatable(Cfg, cfg)
    dump(cfg,"Cfg=")
end

function Main()
    math.randomseed(os.time())
    AdapterToLua:getInstance():setUpdateHandler(Update)
    AdapterToLua:getInstance():setStopHandler(Stop)

    LoadModule()
    LoadConfig()

    fgui.initFgui()
    fgui.UIConfig:registerFont("Dutch801", "res/Dutch801.ttf")
    fgui.UIConfig:setDefaultFont("Dutch801")

    App.New()
    App.Instance:Start()
end

function Update(dt)
    NowTime = NowTime + dt
    App.Instance:Update(dt)
end

function Stop()
    App.Instance:Stop()
end

function EnterBackground()
	LogDebug("EnterBackground function!")
	cc.Director:getInstance():stopAnimation()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
end

function EnterForeground()
	LogDebug("EnterForeground function!")
	cc.Director:getInstance():startAnimation()
    cc.SimpleAudioEngine:getInstance():resumeMusic()    
end 

__G__TRACKBACK__ = function(msg)
    local traceback = debug.traceback()
    LogError(msg .. "\n" .. traceback)
end

local ret, msg = xpcall(Main,__G__TRACKBACK__)


GameRenderQueue = {
	GRQ_UNKNOW = 0,
	GRQ_TERRAIN = 10,														-- 地形层
	GRQ_BLOCK = 20,															-- 阻挡层
	GRQ_SHADOW = 30,														-- 阴影层
	GRQ_SCENE_OBJ = 40,														-- 场景对象
	GRQ_DEFAULT_PS = 50,													-- 默认粒子系统
	GRQ_UI = 60,															-- UI
	GRQ_UI_UP = 70,															-- UI之上的绘制物体
}

XuiTouchEventType = 
{
	BEGAN = 0,
	MOVED = 1,
	ENDED = 2,
	CANCELED = 3
}

COMMON_CONSTS = 
{
	FONT = "res/fonts/Dutch801.ttf"
}

JOYSTICK_EVENT = {
	JOYSTICK_BEGAN = 0,							--按下
	JOYSTICK_TOUCHING = 1,						--按住
	JOYSTICK_ENDED = 2,
}

MAX_ANIMATE_FRAME_COUNT = 0x7fffffff

ANIMATE_TYPE = {
	STAND = "stand",
	WAIT = "wait",
	ATTACK = "atk",
	RUN = "run",
	DEAD = "dead",
	MOVE = "move"
}

ZONE_TYPE = {
	ZONE_TYPE_BLOCK = string.byte('0'),			-- 障碍区
	ZONE_TYPE_WAY = string.byte('1'),				-- 可走区
	ZONE_TYPE_SAFE = string.byte('2'),				-- 安全区
	ZONE_TYPE_DELTA = string.byte('a') - string.byte('0')		-- 阴影差值
}

AnimateEventType = {
	ASYNC_LOAD_FAIL = -1,
	ANIMATE_START = 0,
	ANIMATE_UPDATE = 1,
	ANIMATE_STOP = 2,
}

OBJ_TYPE = {
	ROLE = 1,
	MONSTER = 2
}

------------------------------------------------------------

LUA_FUNCTION = function(self,func)
	return function(...)
		func(self,...)
	end
end

RADIAN_TO_ANGLE = function(radian)
	return radian / math.pi * 180
end

ANGLE_TO_RADIAN = function(angle)
	return angle / 180 * math.pi 
end

function UnPack(param, count, ...)
	if count > #param then
		return ...
	end
	return param[count] , UnPack(param, count+1, ...)
end

function Bind(func, ...)
	local arg1 = {...}
	local f = function(...)
		func(UnPack(arg1, 1, ...))
	end
	return f
end

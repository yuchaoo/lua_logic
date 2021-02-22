setmetatableindex = function(t, index)
    if type(t) == "userdata" then
        local peer = tolua.getpeer(t)
        if not peer then
            peer = {}
            peer.__index = function(t,k)
                return peer[k]
            end
            tolua.setpeer(t, peer)
        end
        setmetatableindex(peer, index)
    else
        setmetatable(t,index)
    end
end

function Class(name,super)
    local baseClass = {}
    package.loaded[name] = baseClass
    local superClass = nil
    local superType = type(super)
    if superType == "table" then
        superClass = super
    elseif superType == "string" then
        superClass = require(super)
    end

    if superClass then
        setmetatable(baseClass,{
            __index = superClass
        })
        baseClass.__super = superClass
        if not superClass.__isUserClass then
            local __create = superClass.create
            if __create then
                baseClass.__create = function()
                    return __create(superClass)
                end
            end
        end
    end
    baseClass.__index = baseClass
    baseClass.__name = name
    baseClass.__className = string.match(name,"%/*(%w+)$")
    baseClass.__isUserClass = true
    baseClass.New = function(...)
        local instance = nil
        if baseClass.__create then
            instance = baseClass:__create()
        else 
            instance = {}
        end

        instance.__base = baseClass
        setmetatableindex(instance,baseClass)

        if baseClass.__init then
            baseClass.__init(instance,...)
        end
        return instance
    end

    baseClass.__init = function(self,...)  end
    baseClass.__delete = function(self)  end
    return baseClass, superClass
end

function IsType(obj, type)
    if not obj then
        return false
    end
    local t = type(obj)
    if t == "userdata" then
        local ret = tolua.type(obj)
        if ret == type then
            return true
        end
    elseif t == "table" then
        obj = obj.__base
        while obj do
            if obj.__name == type then
                return true
            end
            obj = obj.__super
        end
    end
    return false
end

function Cast(obj, class)
    obj:__delete()
    setmetatableindex(obj, class)
    obj:__init()
    return obj
end


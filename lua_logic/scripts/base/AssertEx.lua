--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


function Assert(station,msg)
    if Cfg.debug then
        assert(station,msg)
    end
end

function AssertNumber(number)
    if Cfg.debug then
        Assert(type(number) == "number", string.format("this value type is not number , but a %s",type(number)))
    end
end

function AssertString(str)
    if Cfg.debug then
        Assert(type(str) == "string", string.format("this value type is not string , but a %s",type(str)))
    end
end

function AssertFunc(func)
    if Cfg.debug then
        Assert(type(func) == "function", string.format("this value type is not function , but a %s",type(func)))
    end
end

function AssertObject(obj)
    if Cfg.debug then
        Assert(type(obj) == "userdata" , string.format("this value type is not %s but a %s",type(obj)))
    end
end

function AssertClass(obj,name)
    if Cfg.debug then
        Assert(IsKind(obj,name), string.format("this obj is no type %s",name))
    end
end

function AssertTable(obj)
    if Cfg.debug then
        Assert(type(obj) == "table",string.format("this value type is not table , but a %s",type(obj)))
    end
end

function AssertBool(obj)
    if Cfg.debug then
        Assert(type(obj) == "boolean",string.format("this value type is not boolean , but a %s",type(obj)))
    end
end

--endregion

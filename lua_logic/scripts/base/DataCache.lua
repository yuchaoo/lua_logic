local T , super = Class(...,"scripts/base/Component")

function T:init()
    super.init(self)
    self.data = {}
    self.interval = 0
    self.isDirty = false
    self.path = cc.FileUtils:getInstance():getWritablePath() .. "DataCache"
    self.key = "data"
    self.binit = true
end

function T:onStart()
    if not self.binit then
        self:init()
    end
    super.onStart(self)
    local data = UtilEx:readText(self.path)
    if data and data ~= "" then
        self.data = loadstring(data)()
        dump(data)
    end
end

function T:onStop()
    super.onStop(self)
    self:saveData()
end

function T:getData(key)
    return self.data and self.data[key]
end

function T:setData(key, value)
    self.data[key] = value
    self.isDirty = true
end

function T:saveData()
    local str = TableToString(self.data)
    UtilEx:writeText(self.path,str)
    LogDebug(str)
    self.isDirty = false
end

function T:onUpdate(dt)
    super.onUpdate(self,dt)
    self.interval = self.interval + dt
    if self.interval > 1 and self.isDirty then
        self:saveData()
        self.interval = 0
    end
end
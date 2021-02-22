require("scripts/base/LoadTask")

FguiLoader = Class(...)

local fguiMgr = fgui.PackageManager:getInstance()

function FguiLoader:__init()
    if FguiLoader.Instance then
        LogError("FguiLoader is a singleton , but attemped to create twice")
        return
    end
    FguiLoader.Instance = self
    self.loaders = {}
    self.tmpAdd = {}
    self.updateDeepth = 0
    Runner.Instance:AddRunner(self)
end

function FguiLoader:__delete()
    FguiLoader.Instance = nil
    self.loaders = nil
    Runner.Instance:RemoveRunner(self)
end

function FguiLoader:LoadPackage(pkgName, callback)
    local handler = function()
        local pkg = fguiMgr:createPkg(pkgName,"res/" .. pkgName)
        if callback then
            callback(pgk)
        end
    end
    local task = LoadTask.New()
    task:AddTask(handler)
    if self.updateDeepth > 0 then
        table.insert(self.tmpAdd, task)
    else
        table.insert(self.loaders, task)
    end
end

function FguiLoader:LoadItem(url, callback)
    local pkgName, itemName = string.match(url, "^ui://([%w_]+)/([%w_]+)")
    if pkgName and itemName then
        if not fguiMgr:getPkg(pkgName) then
            self:LoadPackage(pkgName)
        end
        local handler = function()
            local node = fguiMgr:createNodeByName(pkgName, itemName)
            callback(node)
        end
        local task = LoadTask.New()
        task:AddTask(handler)

        if self.updateDeepth > 0 then
            table.insert(self.tmpAdd, task)
        else
            table.insert(self.loaders, task)
        end
    end
end

function FguiLoader:CreateNode(url)
     local pkgName, itemName = string.match(url, "^ui://([%w_]+)/([%w_]+)")
     if pkgName and itemName then
        local pkg = fguiMgr:createPkg(pkgName,"res/" .. pkgName)
        local node = pkg:createNodeByName(itemName)
        return node
     end
end

function FguiLoader:CreatePkg(pkgName)
    fguiMgr:createPkg(pkgName, "res/" .. pkgName)
end

function FguiLoader:Update(dt)
    if #self.loaders <= 0 then
        return
    end
    self.updateDeepth = self.updateDeepth + 1

    local index = 1
    local max = math.min(3, #self.loaders)
    while index <= max do
        local task = self.loaders[index]
        task:ExecuteAll()
        index = index + 1
    end
    self.updateDeepth = self.updateDeepth - 1

    for i = #self.loaders , 1, -1 do
        if self.loaders[i]:IsFinish() then
            table.remove(self.loaders, i)
        end
    end
    if #self.tmpAdd > 0 then
        for i , task in ipairs(self.tmpAdd) do
            table.insert(self.loaders, task)
        end
        self.tmpAdd = {}
    end
end

---------------------------------------------

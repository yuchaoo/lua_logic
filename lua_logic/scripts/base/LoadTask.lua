LoadTask = Class(...)

function LoadTask:__init()
    self.task = {}
    self.callback = nil
    self.curIndex = 0
end

function LoadTask:__delete()
    self.task = nil
    self.callback = nil
end

function LoadTask:AddTask(func)
    table.insert(self.task, func)
end

function LoadTask:SetCallBack(func)
    self.callback = func
end

function LoadTask:CallBack()
    if self.callback then
        self.callback()
    end
end

function LoadTask:IsFinish()
    return self.curIndex >= #self.task
end

function LoadTask:GetTotal()
    return #self.task
end

function LoadTask:GetFinish()
    return self.curIndex
end

function LoadTask:ExecuteAll()
    for i , handler in ipairs(self.task) do
        handler()
    end
    self.curIndex = #self.task
end

function LoadTask:ExecuteOnce()
    self.curIndex = self.curIndex + 1
    if self.curIndex <= #self.task then
        local handler = self.task[self.curIndex]
        handler()
    end
    return self.curIndex >= #self.task
end


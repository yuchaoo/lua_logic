Timer = Class(...)

local TimerType = {
    kDelay = 1,
    kLoop = 2
}

function Timer:__init()
    self.timers = {}
    self.updating = 0
    self.tmpList = {}
end

function Timer:__delete()
    self.timers = nil
    self.updating = nil
    self.tmpList = nil
end

function Timer:DelayCallBack(delay, callback)
    local timer = {
        type = TimerType.kDelay,
        delay = delay,
        callback = callback,
        escape = 0
    }
    if self.updating > 0 then
        table.insert(self.tmpList, timer)
    else
        table.insert(self.timers,timer)
    end
    if not Runner.Instance:IsHasRunner(self) then
        Runner.Instance:AddRunner(self)
    end
end

function Timer:LoopCallBack(delay, interval, loop, callback)
    local timer = {
        type = TimerType.kLoop,
        delay = delay or 0,
        interval = interval or 0.03,
        loop = loop or 1,
        callback = callback,
        escape = 0,
        count = 0
    }
    if self.updating > 0 then
        table.insert(self.tmpList, timer)
    else
        table.insert(self.timers, timer)
    end
end

function Timer:Stop()
    self.timers = {}
    self.updating = 0
    self.tmpList = {}
    Runner.Instance:RemoveRunner(self)
end

function Timer:UpdateDelay(timer, dt)
    timer.escape = timer.escape + dt
    if timer.escape >= timer.delay then
        timer.callback()
        return true
    end
    return false
end

function Timer:UpdateLoop(timer, dt)
    timer.escape = timer.escape + dt
    if timer.escape < timer.delay then
        return false
    end
    if timer.escape >= timer.delay + timer.interval * (timer.count + 1) then
        timer.count = timer.count + 1
        timer.callback()
        if timer.loop > 0 and timer.count > timer.loop then
            return true
        end
    end
    return false
end

function Timer:Update(dt)
    self.updating = self.updating + 1
    for i , timer in ipairs(self.timers) do
        if timer.type == TimerType.kDelay then
            timer.finish = self:UpdateDelay(timer, dt)
        elseif timer.type == TimerType.kLoop then
            timer.finish = self:UpdateLoop(timer, dt)
        end
    end
    self.updating = self.updating - 1
    for i = 1, #self.timers, -1 do
        if self.timers[i].finish then
            table.remove(self.timers,i)
        end
    end
    if #self.tmpList > 0 then
        for i , timer in ipairs(self.tmpList) do
            table.insert(self.timers, timer)
        end
        self.tmpList = {}
    end
    if #self.timers <= 0 then
        self:Stop()
    end
end

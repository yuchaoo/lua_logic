Runner = Class(...)

function Runner:__init()
    if Runner.Instance then
        LogError("the Runner is attemp create twice")
        return
    end
    Runner.Instance = self
    self.runners = HashList.New()
    self.runing = 0
    self.tmpAddList = {}
    self.tmpRemoveList = {}
end

function Runner:__delete()
    self.runners:Clear()
    self.tmpAddList = nil
    self.tmpRemoveList = nil
    Runner.Instance = nil
end

function Runner:AddRunner(runner)
    if self.runing > 0 then
        table.insert(self.tmpAddList,runner)
    else
        self.runners:AddObj(runner)
    end
end

function Runner:RemoveRunner(runner)
    if self.runing > 0 then
        table.insert(self.tmpRemoveList, runner)
    else
        self.runners:RemoveObj(runner)
    end
end

function Runner:IsHasRunner(runner)
    if self.runners:HasObj(runner) then
        return true
    end
    if self.runing > 0 and #self.tmpAddList > 0 then
        for i , r in ipairs(self.tmpAddList) do
            if runner == r then
                return true
            end
        end
    end
    return false
end

function Runner:Update(dt)
    self.runing = self.runing + 1
    if not self.escape then
        self.escape = dt
    else
        self.escape = self.escape + dt
    end
    local bAcross = self.escape >= 1.0
    if bAcross then
        self.escape = self.escape - 1
    end
    for runner in self.runners:Iter() do
        if runner.Update then
            runner:Update(dt)
        end
        if bAcross and runner.Second then
            runner:Second()
        end
    end
    self.runing = self.runing - 1

    if #self.tmpAddList > 0 then
        for i , runner in ipairs(self.tmpAddList) do
            self.runners:AddObj(runner)
        end
        self.tmpAddList = {}
    end

    if #self.tmpRemoveList > 0 then
        for i , runner in ipairs(self.tmpRemoveList) do
            self.runners:RemoveObj(runner)
        end
        self.tmpRemoveList = {}
    end
end


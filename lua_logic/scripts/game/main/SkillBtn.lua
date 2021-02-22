local SkillBtn = Class(..., BaseView)

function SkillBtn:__init()
    SkillBtn.__super.__init(self)
end

function SkillBtn:OnDeleteCallBack()
    Runner.Instance:RemoveRunner(self)
end

function SkillBtn:OnCreateCallBack()
    SkillBtn.__super.OnCreateCallBack(self)
    self.icon = self:GetChild("icon")
    self.mask = self:GetChild("mask")
    self.escape = 0
    self.cd = 3
    self.isStart = false
    self.__view:setClickListener(Bind(self.OnClick, self))
end

function SkillBtn:OnFlush()
    local progress = 1 - math.min(1, self.escape / self.cd)
    self.mask:setFillAmount(progress)
end

function SkillBtn:StartCD()
    if self.isStart then
        return
    end
    self.escape = 0
    self.isStart = true
    Runner.Instance:AddRunner(self)
end

function SkillBtn:StopCD()
    if not self.isStart then
        return
    end
    self.isStart = false
    Runner.Instance:RemoveRunner(self)
end

function SkillBtn:OnClick()
    LogDebug("OnClick...")
    self:StartCD()
end

function SkillBtn:Update(dt)
    if not self.isStart then
        return
    end
    self.escape = self.escape + dt
    self:OnFlush()
    if self.escape >= self.cd then
        self:StopCD()
    end
end
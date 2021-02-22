BaseData = Class(..., BaseCom)

function BaseData:InitListener()
    
end

function BaseData:RemoveListener()
    self.__super.RemoveListener(self)
end


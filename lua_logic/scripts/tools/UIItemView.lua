local T , super = Class(...,"scripts/base/BaseView")

function T:init(info)
    super.init(self,info)
    self.id = info.id
    self.num = info.num
end

function T:initView(root)
    local size = cc.size(80,80)
    root:getContentSize(size)
    root:setBackGroundColor(cc.c3b(25,255,0))

    self.bg = xui.createScale9Sprite({
        res = "res/zjm_map_di.png",
        isPlist = false,
        pos = cc.p(size.width / 2, size.height / 2),
        size = size
    })
    root:addChild(self.bg)

    self.icon = xui.createImage({
        res = string.format("res/item/%d.png",self.id) ,
        isPlist = false,
        pos = cc.p(size.width / 2, size.height / 2)
    })
    root:addChild(self.icon)
    
    self.numTxt = xui.createText({
        text = self.num,
        fontSize = 16,
        hAlign = cc.TEXT_ALIGNMENT_RIGHT
    })
    root:addChild(self.numTxt)
    self.numTxt:setPosition(cc.p(size.width - 15 , 10))
end

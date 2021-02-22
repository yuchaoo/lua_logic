xui = {}

function setNodeAttribute(node, info)
    if info.pos then
        node:setPosition(info.pos)
    end
    if info.size then
        node:setContentSize(info.size)
    end
    if info.achor then
        node:setAnchorPoint(info.achor)
    end
    if info.rotation then
        node:setRotation(info.rotation)
    end
    if info.flipx then
        node:setFlippedX(info.flipx)
    end
    if info.flipy then
        node:setFlippedY(info.flipy)
    end
    if info.scale then
        node:setScale(info.scale)
    end
end

xui.createButton = function(info)
    local button = XButton:create(
        info.res,
        info.select or "",
        info.disable or "",
        not (info.isPlist == false)
    )
    if info.title then
        button:setTitleText(info.title)
        button:setTitleFontSize(info.fontSize or 20)
        button:setTitleFontName(info.fontName or COMMON_CONSTS.FONT)
    end
    setNodeAttribute(button,info)
    return button
end

xui.createImage = function(info)
    local image = XImage:create(
        info.res,
        not (info.isPlist == false)
    )
    setNodeAttribute(image,info)
    return image
end

xui.createScale9Sprite = function(info)
    local scale9 = nil
    if info.res and info.rect and info.capInsets then
        scale9 = XScale9Sprite:create(info.res,info.rect,info.capInsets)
    elseif info.res and info.rect then
        scale9 = XScale9Sprite:create(info.res,info.rect)
    elseif info.res and info.capInsets then
        scale9 = XScale9Sprite:create(info.capInsets,info.res)
    else
        scale9 = XScale9Sprite:create(info.res)
    end
    setNodeAttribute(scale9,info)
    return scale9
end

xui.createText = function(info)
    Assert(info.text)
    local txt = XText:create(tostring(info.text),info.fontName or COMMON_CONSTS.FONT,info.fontSize or 20)
    if info.color then
        txt:setTextColor(info.color)
    end
    if info.hAlign then
        txt:setHorizontalAlignment(info.hAlign)
    end
    if info.vAlign then
        txt:setVerticalAlignment(info.vAlign)
    end
    setNodeAttribute(txt,info)
    return  txt
end

xui.createAnimate = function(info)
    local animate = AnimateSprite:create(info.res,info.name,info.loops or MAX_ANIMATE_FRAME_COUNT, info.interval or 0.1, info.flipx or false)
    setNodeAttribute(animate,info)
    return animate
end

xui.createJoystick = function(info)
    Assert(info.bg and info.joystick)
    local joystick = XJoystick:create(info.bg,info.joystick,not (info.isPlist == false))
    setNodeAttribute(joystick,info)
    return joystick
end

xui.createLayout = function(info)
    local layout = XLayout:create()
    if info.color then
        layout:setBackGroundColor(info.color)
    end
    if info.opacity then
        layout:setBackGroundColorOpacity(info.opacity)
    end
    setNodeAttribute(layout, info)
    return layout
end

xui.createProgressBar = function(info)
    local loadingBar = XLoadingBar:create()
    if info.res then
        loadingBar:loadTexture(info.res, not (info.isPlist == false))
    end
    if info.bg  then
        loadingBar:loadBgTexture(info.bg, not (info.isPlist == false))
    end
    setNodeAttribute(loadingBar, info)
    return loadingBar
end

xui.createImageNumber = function(info)
    local ImageNumber = require("scripts/render/ImageNumber")
    local text = ImageNumber:create(info)
    setNodeAttribute(text,info)
    return text
end

xui.createEditBox = function(info)
    local editBox = XEditBox:create(info.size or cc.size(50,30), info.bgPath or "")
    if info.text then
        editBox:setText(info.text)
    end
    if info.fontSize and info.fontName then
        editBox:setFont(info.fontName , info.fontSize)
    elseif info.fontSize then
        editBox:setFont(COMMON_CONSTS.FONT, info.fontSize)
    elseif info.fontName then
        editBox:setFont(info.fontName, 20)
    end
    if info.color then
        editBox:setFontColor(info.color)
    end
    if info.holder then
        editBox:setPlaceHolder(info.holder)
    end
    if info.holderFontName and info.holderFontSize then
        editBox:setPlaceholderFont(info.holderFontName,info.holderFontSize)
    elseif info.holderFontName then
        editBox:setPlaceholderFont(info.holderFontName,20)
    elseif info.holderFontSize then
        editBox:setPlaceholderFont(COMMON_CONSTS.FONT, info.holderFontSize)
    end

    if info.holderColor then
        editBox:setPlaceholderFontColor(info.holderColor)
    end

    if info.maxLen then
        editBox:setMaxLength(info.maxLen)
    end

    if info.inputMode then
        editBox:setInputMode(info.inputMode)
    end
    if info.hAlign then
        editBox:setHorizontalAlignment(info.hAlign)
    end
    if info.vAligh then
        editBox:setVerticalAlignment(info.vAligh)
    end
    setNodeAttribute(editBox,info)
    return editBox
end
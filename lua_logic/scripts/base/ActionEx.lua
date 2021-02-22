util = util or {}

Ease = { 
EaseIn = "easeIn", 
EaseOut = "easeOut", 
EaseInOut = "easeInOut", 
EaseExpIn = "EaseExponentialIn", 
EaseExpOut = "EaseExponentialOut", 
EaseExpnInOut = "EaseExponentialInOut",
EaseSineIn = "EaseSineIn", 
EaseSineOut = "EaseSineOut", 
EaseSineInOut = "EaseSineInOut",
EaseElastic = "EaseElastic",  
EaseElasticIn = "EaseElasticIn", 
EaseElasticOut = "EaseElasticOut", 
EaseElasticInOut = "EaseElasticInOut", 
EaseBounce = "EaseBounce", 
EaseBounceIn = "EaseBounceIn", 
EaseBounce = "EaseBounce", 
EaseBounceIn = "EaseBounceIn", 
EaseBounceOut = "EaseBounceOut", 
EaseBackIn = "EaseBackIn", 
EaseBackOut = "EaseBackOut",  
EaseBackInOut = "EaseBackInOut",
EaseBezier = "EaseBezierAction", 
EaseQuadraticIn = "EaseQuadraticActionIn", 
EaseQuadraticOut = "EaseQuadraticActionOut", 
EaseQuadraticInOut = "EaseQuadraticActionInOut",
EaseQuarticIn = "EaseQuarticActionIn", 
EaseQuarticOut = "EaseQuarticActionOut", 
EaseQuarticInOut = "EaseQuarticActionInOut",
EaseQuinticIn = "EaseQuinticActionIn", 
EaseQuinticOut = "EaseQuinticActionOut", 
EaseQuinticInOut = "EaseQuinticActionInOut",
EaseCircleIn = "EaseCircleActionIn", 
EaseCircleOut = "EaseCircleActionOut", 
EaseCircleInOut = "EaseCircleActionInOut",
EaseCubicIn = "EaseCubicActionIn" , 
EaseCubicOut = "EaseCubicActionOut", 
EaseCubicInOut = "EaseCubicActionInOut"
}

function util.ScaleTo(time,value,ease,...)
    local action = cc.ScaleTo:create(time,value)
    if ease and  cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.ScaleBy(time,value,ease,...)
    local action = cc.ScaleBy:create(time,value)
    if ease and  cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.Blink(time,count)
    return cc.Blink:create(time,count)
end

function util.FadeTo(time,value,ease,...)
    local action = cc.FadeTo:create(time,value)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.FadeIn(time,ease,...)
    local action = cc.FadeIn:create(time)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.FadeOut(time,ease,...)
    local action = cc.FadeOut:create(time)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.TintTo(time,color,ease,...)
    local action = cc.TintTo:create(time,color.r,color.g,color.b)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.TintBy(time,color,ease,...)
    local action = cc.TintBy:create(time,color.r,color.g,color.b)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.Delay(time)
    return cc.DelayTime:create(time)
end

function util.Reverse(action)
    return cc.ReverseTime:create(action)
end

function util.Animate(animation)
    return cc.Animate:create(animation)
end

function util.BezierTo(time,config,ease,...)
    local action = cc.BezierTo:create(time,config)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.BezierBy(time,config,ease,...)
    local action = cc.BezierBy:create(time,config)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.JumpTo(time,pos,height,count,ease,...)
    local action = cc.JumpTo:create(time,pos,height,count)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.JumpBy(time,pos,height,count,ease,...)
    local action = cc.JumpBy:create(time,pos,height,count)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.SkewBy(time,skewX,skewY,ease,...)
    local action = cc.SkewBy:create(time,skewX,skewY)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.SkewTo(time,skewX,skewY,ease,...)
    local action = cc.SkewTo:create(time,skewX,skewY)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.MoveTo(time,pos,ease,...)
    local action = cc.MoveTo:create(time,pos)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.MoveBy(time,pos,ease,...)
    local action = cc.MoveBy:create(time,pos)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.RotateBy(time,angle,ease,...)
    local action = cc.RotateBy:create(time,angle)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.RotateTo(time,angle,ease,...)
    local action = cc.RotateTo:create(time,angle)
    if ease and cc[ease] then
        return cc[ease]:create(action,...)
    end
    return action
end

function util.Spawn(action1,action2,...)
    Assert(action1)
    Assert(action2)
    local action = cc.Spawn:create(action1,action2,...)
    return action
end

function util.Forever(action)
    return cc.RepeatForever:create(action)
end

function util.Repet(action,count)
    return cc.Repeat:create(action,count)
end

function util.Sequence(action1,action2,...)
    Assert(action1)
    Assert(action2)
    return cc.Sequence:create(action1,action2,...)
end

function util.Show()
    return cc.Show:create()
end

function util.Hide()
    return cc.Hide:create()
end

function util.RemoveSelf()
    return cc.RemoveSelf:create()
end

function util.FlipX()
    return cc.FlipX:create()
end

function util.FlipY()
    return cc.FlipY:create()
end

function util.Place(pos)
    return cc.Place:create(pos)
end

function util.Callfunc(handler)
    return cc.CallFunc:create(handler)
end

function util.ProgressTo(time,value)
    return cc.ProgressTo:create(time,value)
end

function util.ProgressFromTo(time,from,to)
    return cc.ProgressFromTo:create(time,from,to)
end
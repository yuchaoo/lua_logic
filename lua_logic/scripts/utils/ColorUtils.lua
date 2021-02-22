ColorUtils = ColorUtils or {}

ColorUtils.HexToRGB = function(hex)
    if string.sub(hex, 1, 1) == '#' then
        hex = string.sub(hex, 2)
    end
    local r = tonumber(string.sub(hex, 1, 2), 16)
    local g = tonumber(string.sub(hex, 3, 4), 16)
    local b = tonumber(string.sub(hex, 5, 6), 16)
    return {
        r = r,
        g = g,
        b = b
    }
end

ColorUtils.DecToHex = function (dec)
    local b, k, out, i, d = 16, "0123456789ABCDEF", "", 0
    while dec > 0 do
        i = i + 1
        dec, d = math.floor(dec / b), math.fmod(dec, b) + 1
        out = string.sub(k, d, d) .. out
    end
    return out
end

ColorUtils.RgbToHex =  function(c)
    return xui.decToHex(c.r) .. xui.decToHex(c.g) .. xui.decToHex(c.b)
end
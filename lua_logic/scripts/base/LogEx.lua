LgLv = {
    INFO = 1,
    DEBUG = 2,
    WARING = 3,
    ERROR = 4
}

local isRestart = true

function LogFile(msg)
    if isRestart then
        local file = io.open("log.txt","w")
        file:write(msg .. "\n")
        io.close(file)
        isRestart = false
    else
        local file = io.open("log.txt","a")
        file:write(msg .. "\n")
        io.close(file)
    end
end

function Log(msg, lv)
    lv = lv or LgLv.INFO
    local info = debug.getinfo(3)
    local s = string.match(info.source, ".*/([%w_]+%.lua)$" )
    if s then
        msg = s .. ":line" .. info.currentline .. "\t" .. msg
    end

    if Cfg.debug or lv >= LgLv.WARING then
        print(msg)
        if Cfg.isWin32 then
            LogFile(msg)
        end
    end
end

function LogDebug(format,...)
    local str = ... and string.format(format,...) or format
    Log(str,LgLv.DEBUG)
end

function LogWarning(format,...)
    local str = string.format(format,...)
    Log(str,LgLv.WARING)
end

function LogError(format,...)
    local str = string.format(format,...)
    Log(str,LgLv.ERROR)
end

function LogInfo(format,...)
    local str = string.format(format,...)
    Log(str,LgLv.INFO)
end

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function DumpValue(value, description, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local function dump_(value, description, indent, nest, keylen)
        description = description or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(description)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(description), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(description), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(description))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(description))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, description, "", 1)
    local msg = ""
	for i, line in ipairs(result) do
        msg = msg .. line .. "\n"
    end
    return msg
end

--输出table
function dump(value, description, nesting)
    local msg = DumpValue(value,description,nesting)
    LogInfo(msg)
end

function TableToString(data)
    local printChar , keyToString , valueToString, tableToString

    printChar = function(c,num)
        return string.rep(c,num)
    end

    keyToString = function(key)
        local keystr = ""
        if type(key) == "number" then
            keystr = "[" .. key .. "]"
        else
            keystr = tostring(key)
        end
        return keystr
    end
    
    valueToString = function(value,deep)
        local valuestr = ""
        if type(value) == "table" then
            valuestr = tableToString(value, "", deep + 1)
        elseif type(value) == "string" then
            valuestr = "\'" .. value .. "\'"
        else
            valuestr = tostring(value)
        end
        return valuestr
    end

    tableToString = function(t,retstr, deep)
        retstr = retstr .. "{\n"
        for key , value in pairs(t) do
            retstr = retstr .. printChar('  ',deep) .. keyToString(key) .. " = " .. valueToString(value,deep + 1) .. ",\n"
        end
        retstr = retstr .. printChar(' ',deep) .. "}"
        return retstr
    end
    local str = "return " ..  tableToString(data,"",1)
    return str
end 

--endregion

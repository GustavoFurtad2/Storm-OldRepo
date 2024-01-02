require "interpreter"
require "util"

Var = {}
Var.__index = Var

Var.AssignType = function(value)
    local v
    if string.match(value, '^".*"$') or string.match(value, "^'.*'$") then
        v = tostring(value:sub(-2,2))
    elseif tonumber(value) ~= nil then
        v = tonumber(value)
    end

    return v
end

Var.New = function(name, value)
    _All[name] = value
end

Var.New("log", function(str)
    print(FormatString(str))
end)

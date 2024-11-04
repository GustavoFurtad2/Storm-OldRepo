require "interpreter/env"

function error(errorType, message)

    crashed = true
    print(errorType .. " at line " .. currentLine .. ": " .. message)
end

function split(s, delimiter)

    local result = {}

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end

    return result
end

function getVariable(variableName, variableType)

    local variablePath = _GLOBAL[variableName]
    print(variablePath)

    local object = split(variableName, "%.")

    if #object > 1 then

        variablePath = _GLOBAL[object[1]]

        table.remove(object, 1)

        for i, child in next, object do

            if i == #object then
                child = child:sub(1, child:len() - 1)
            end

            local sucess = pcall(function()

                variablePath = variablePath[child]
            end)

            if not sucess then

                error("Runtime Error", string.format("'%s' %s doesn't exist", variableName, variableType))
                return
            end
        end
    end

    return variablePath
end

function isAlpha(s)
    return s:lower() ~= s:upper()
end

function isNumber(s)
    return tonumber(s) ~= nil
end

function isVariable(value)

    return _GLOBAL[value]
end

function toValue(value)
   
    local variable = getVariable(value)

    if variable then

        return variable
    end

    if string.match(value, "[+%-*/]") or string.match(value, "%.%.") then
 
        return load("return " .. value, nil, nil, _GLOBAL)()
      
    elseif string.match(value, [[^["'].-["']$]]) then
 
        return value:sub(2, -2)
 
   elseif value == "true" then
 
        return true
 
   elseif value == "false" then
 
        return false
 
   elseif tonumber(value) ~= nil then
 
        return tonumber(value)
 
   elseif onScope and currentScope.args[value] then

        return currentScope.args[value]
 
   elseif not value:match("^[\"'].-[\"']$") then

   else

        return nil
   end
end

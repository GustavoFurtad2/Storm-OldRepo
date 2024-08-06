require "interpreter/env"
require "interpreter/utils"

function callFunction()

    local args = split(nextToken.value, ",")
    nextToken.active = false

    for i in next, args do
        args[i] = toValue(args[i])
    end

    if onScope then
        
        local func = currentToken.value
        currentScope:newInstruction(function()
            _GLOBAL[func](table.unpack(args))
        end)

        return
    end

    local sucess = pcall(function() 
        _GLOBAL[currentToken.value](table.unpack(args))
    end)

    if not sucess then
        error("Runtime Error", string.format("'%s' function doesn't exist", currentToken.value))
    end
end

function makeVariable(name, value)

    local firstChar = name:sub(1,1)
    if not isAlpha(firstChar) and firstChar ~= "_" then
        error("Assign Error", "Variable names cannot start with special characters or numbers")
        return
    end

    nextToken.active = false
    nextNextToken.active = false

    if type(value) == "function" then

        _GLOBAL[currentToken.value] = tostring(value):sub(-1) == ")" and value() or value
        return
    end

    _GLOBAL[currentToken.value] = value
end

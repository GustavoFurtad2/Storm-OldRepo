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

    _GLOBAL[currentToken.value](table.unpack(args))
end

function makeVariable(name, value)

    local firstChar = name:sub(1,1)
    if not isAlpha(firstChar) and firstChar ~= "_" then
        error("Assign Error", "Variable names cannot start with special characters or numbers")
        return
    end

    nextToken.active = false
    nextNextToken.active = false

    if type(value) == "function" and tostring(value):sub(-1) == ")" then

        if onScope then
        
            local var = currentToken.value
            currentScope:newInstruction(function()
                _GLOBAL[currentToken.value] = value()
            end)
    
            return
        end

        _GLOBAL[currentToken.value] = value()
    else

        if onScope then
        
            local var = currentToken.value
            currentScope:newInstruction(function()
                _GLOBAL[currentToken.value] = value
            end)
    
            return
        end

        _GLOBAL[currentToken.value] = value
    end
end

require "interpreter/env"
require "interpreter/utils"

local function execute(code)

    local executed 

    if not onScope then

        executed = pcall(function()
            code()
        end)
    else

        executed = pcall(function()
            currentScope:newInstruction(code)
        end)
    end

    return executed
end

function callFunction()

    local args = split(nextToken.value, ",")

    for i in next, args do
        args[i] = toValue(args[i])
    end

    local funcName = currentToken.value
    
    if type(_GLOBAL[funcName]) == "function" then

        local call = execute(function()

            _GLOBAL[funcName](table.unpack(args))
        end)

        return
    end

    error("Runtime Error", string.format("'%s' function doesn't exist", funcName))
end

function setVariable()

    local varName  = currentToken.value
    local value    = nextNextToken.value
    
    nextToken.active = false
    nextNextToken.active = false

    local firstChar = varName:sub(1,1)
    if not isAlpha(firstChar) and firstChar ~= "_" then
        error("Assign Error", "variable names cannot start with special characters or numbers")
        return
    end

    if type(_GLOBAL[value]) == "function" then

        if nextNextNextToken.type == tokenType["args"] then

            nextNextNextToken.active = false

            execute(function()

                _GLOBAL[varName] = _GLOBAL[value]()
            end)

        else

            execute(function()

                _GLOBAL[varName] = _GLOBAL[value]
            end)
        end

        return

    end

    execute(function()

        _GLOBAL[varName] = value
    end)

end

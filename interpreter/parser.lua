require "interpreter/env"
require "interpreter/utils"

local currentToken, nextToken, nextNextToken, nextNextNextToken

local function callFunction()

    local args = split(nextToken.value, ",")
    nextToken.active = false

    for i in next, args do
        args[i] = toValue(args[i])
    end

    _GLOBAL[currentToken.value](table.unpack(args))
end

local function makeVariable(name, value)

    local firstChar = name:sub(1,1)
    if not isAlpha(firstChar) and firstChar ~= "_" then
        error("Assign Error", "Variable names cannot start with special characters or numbers")
        return
    end

    nextToken.active = false
    nextNextToken.active = false

    if type(value) == "function" and tostring(value):sub(-1) == ")" then
        _GLOBAL[currentToken.value] = value()
    else
        _GLOBAL[currentToken.value] = value
    end
end


local function tryMakeVariable()

    if nextNextToken ~= nil then

         if nextNextToken.type == tokenType["Identifier"] then


            if nextNextNextToken ~= nil then
                if nextNextNextToken.type == tokenType["Call"] then

                    local funcName = nextNextToken.value

                    makeVariable(currentToken.value, _GLOBAL[funcName]())
                    nextNextNextToken.active = false
                    return
                end
            end

            makeVariable(currentToken.value, toValue(nextNextToken.value))
         end
    else

        error("Type Error", "Expected value for variable assignment")
    end
end

local function identify()

    if nextToken == nil then

        error("Type Error", "'=' expected")
        return
    end

    if nextToken.type == tokenType["Call"] then

        callFunction()
    elseif nextToken.type == tokenType["Equals"] then
        
        tryMakeVariable()
    end
end

function parser()

    for index, token in next, tokens[currentLine] do

        if crashed then
            break
        end

        if token.active == true then

            currentToken      = token
            nextToken         = tokens[currentLine][index + 1]
            nextNextToken     = tokens[currentLine][index + 2]
            nextNextNextToken = tokens[currentLine][index + 3]

            if token.type == tokenType["Identifier"] then

                identify()

            else
                error("Type Error", "'" .. token.value .. "' unexpected.")
            end
        end
    end
end
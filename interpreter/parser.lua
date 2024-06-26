require "interpreter/env"
require "interpreter/utils"

local currentToken, nextToken, nextNextToken

local function callFunction()

    local args = split(nextToken.value, ",")
    nextToken.active = false

    for i in next, args do
        args[i] = toValue(args[i])
    end

    _GLOBAL[currentToken.value](table.unpack(args))
end

local function makeValue(name, value)

    if tonumber(name:sub(1,1)) ~= nil then
        print("Init Error : Variables can't start with numbers")
        return
    end
    nextToken.active = false
    nextNextToken.active = false
    _GLOBAL[currentToken.value] = value
end


local function tryMakeVariable()

    if nextNextToken ~= nil then

         if nextNextToken.type == tokenType["Identifier"] then

            makeValue(currentToken.value, toValue(nextNextToken.value))
         end
    else

    end
end

local function identify()

    if nextToken == nil then
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

            currentToken     = token
            nextToken        = tokens[currentLine][index + 1]
            nextNextToken    = tokens[currentLine][index + 2]

            if token.type == tokenType["Identifier"] then

                identify()
            end
        end
    end
end
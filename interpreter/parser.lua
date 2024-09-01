require "interpreter/env"
require "interpreter/utils"
require "interpreter/scope"
require "interpreter/runtime"

local function tryMakeVariable()

    if nextNextToken ~= nil then

        if nextNextToken == tokenType["identifier"] and nextNextNextToken ~= nil then

            if nextNextNextToken.type == tokenType["call"] then

                local funcName = nextNextToken.value

                makeVariable(currentToken.value, _GLOBAL[funcName]())
                nextNextNextToken.active = false

                return
            end
        end
    end

    error("Type Error", "Expected value for variable assignment")
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

local function func()

    if nextToken == nil then

        error("Type Error", "Expected function name assignment")
        return
    end

    if nextNextToken == nil then

        error("Type Error", "'(' expected")
        return
    end

    nextToken.active     = false
    nextNextToken.active = false

    if nextToken.type == tokenType["Identifier"] then

        local firstChar = nextToken.value:sub(1,1)
        if not isAlpha(firstChar) and firstChar ~= "_" then
            error("Assign Error", "Function names cannot start with special characters or numbers")
            return
        end

    end

    scopes[nextToken.value] = scope(nextToken.value)
    currentScope = scopes[nextToken.value]

    if nextNextToken.type == tokenType["Call"] and nextNextToken.value:len() > 0 then
        
        local args = split(nextToken.value, ",")
        for i in next, args do
            currentScope.args[args[i]] = true
        end
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
            elseif token.type == tokenType["Function"] then

                func()

            elseif token.type == tokenType["End"] then

                openScopes = openScopes - 1
                onFunction = false

                if openScopes < 0 then

                    error("Type Error'", "'end' unexpected")
                elseif openScopes == 0 then

                    onScope = false
                end

                _GLOBAL[currentScope.name] = function()

                    currentScope:execute()
                end
            else
                error("Type Error", "'" .. token.value .. "' unexpected.")
            end
        end
    end
end

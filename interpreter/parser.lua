require "interpreter/env"
require "interpreter/utils"
require "interpreter/scope"
require "interpreter/runtime"

local function identify()

    if not nextToken then

        error("Type Error", "'=' expected at line " .. currentLine)
        return
    end

    nextToken.active = false

    if nextToken.type == tokenType["args"] then

        callFunction()
    elseif nextToken.type == tokenType["assign"] then

        setVariable()
    end
end

local function func()

    if not nextToken then

        error("Type Error", "expected function name assignment")
        return
    end

    if not nextNextToken then

        error("Type Error", "'()' expected to open function")
        return
    end

    nextToken.active, nextNextToken.active = false, false

    if nextToken.type == tokenType["identifier"] then

        local firstChar = nextToken.value:sub(1,1)

        if not isAlpha(firstChar) and firstChar ~= "_" then

            error("Assign Error", "function names cannot start with special characters or numbers")
            return
        end

    end

    local scopeName = nextToken.value
    scopes[scopeName] = Scope:new(scopeName)

    currentScope = scopes[scopeName]
    
end

function parser()

    for index, token in next, tokens[currentLine] do

        if crashed then
            return
        end

        if token.active then

            currentToken      = token
            nextToken         = tokens[currentLine][index + 1]
            nextNextToken     = tokens[currentLine][index + 2]
            nextNextNextToken = tokens[currentLine][index + 3]

            if token.type == tokenType["identifier"] then

                identify()
            elseif token.type == tokenType["function"] then

                func()
            elseif token.type == tokenType["end"] then

                openScopes = openScopes - 1
                onFunction = false

                if openScopes < 0 then

                    error("Type Error", "'end' unexpected at line " .. currentLine)
                elseif openScopes == 0 then

                    onScope = false
                end

                _GLOBAL[currentScope.name] = function()

                    currentScope:execute()
                end

            else

                error("Type Error", string.format("'%s' unexpected", token.value))
            end
        end
    end
end

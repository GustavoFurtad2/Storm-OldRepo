require "interpreter/env"
require "interpreter/utils"

local function appendToken(type)

    table.insert(tokens[currentLine], {value = tokenSet, type = type, active = true})
end

local keywords = {

    ["func"] = function()
    
        onFunction = true
        appendToken(tokenType["function"])
        tokenSet = ""
    end,
    
    ["end"] = function()

        appendToken(tokenType["end"])
        tokenSet = ""
    end,
    
}

local function processString()

    onString = not onString
    tokenSet = tokenSet .. currentChar

    if not onString and not onCallFunction or charIndex == lineLength then

        appendToken(tokenType["identifier"])
        tokenSet = ""
    end

    lastSpace = false

end

local function processOpenParentheses()

    openParentheses = openParentheses + 1
       
    if not onFunction then

        onCallFunction = true

        local append = pcall(function()
            appendToken(tokenType["identifier"])
        end)

        if not append then

            error("Runtime Error", "'" .. tokenSet .. "' was not defined")
            return
        end

        tokenSet = ""
        lastSpace = false

        return
    end

    appendToken(tokenType["identifier"])
    tokenSet = ""

end

local function processCloseParentheses()

    openParentheses = openParentheses - 1

    if openParentheses == 0 then

        appendToken(tokenType["args"])

        onCallFunction = false
        onFunction = false

        tokenSet = ""

    end

    lastSpace = false

end

local function processAssign()

    if openParentheses == 0 then
 
        if not keywords[tokenSet] then
        
            if not lastSpace then
                appendToken(tokenType["identifier"])
            end

            tokenSet = "="
            appendToken(tokenType["assign"])
            tokenSet = ""

        end
    end

    lastSpace = false

end

function processSpace()

    if openParentheses == 0 and not onString then

        if not keywords[tokenSet] then

            appendToken(tokenType["identifier"])

        else

            appendToken(tokenType["keyword"])
        end

        tokenSet = ""
        lastSpace = true
    end

end

function tokenize()

    if crashed then
        return
    end

    if currentChar == '"' or currentChar == "'" then
        processString()

    elseif currentChar == "(" and not onString then
        processOpenParentheses()
    
    elseif currentChar == ")" and not onString then
        processCloseParentheses()
    
    elseif currentChar == "=" then
        processAssign()
    
    elseif currentChar == " " and tokenSet:len() ~= 0 and not onString and not onCallFunction and not lastEmpty then
        processSpace()

    else

        if keywords[tokenSet .. currentChar] then

            tokenSet = tokenSet .. currentChar
            keywords[tokenSet]()

            return
        end

        if charIndex == lineLength then

            tokenSet = tokenSet .. currentChar
            appendToken(tokenType["identifier"])

        elseif currentChar ~= " " or onString then

            tokenSet = tokenSet .. currentChar
        end

        lastSpace = false

    end
end

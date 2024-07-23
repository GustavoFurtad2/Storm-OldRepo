require "interpreter/env"
require "interpreter/utils"

local function appendToken(type)

    table.insert(tokens[currentLine], {value = set, type = type, active = true})
end

local keywords = {
    ["function"] = function()

        onFunction = true
        appendToken(tokenType["Function"])
        set = ""
    end,
    ["end"] = function()

        appendToken(tokenType["End"])
        set = ""
    end,
}

local function processString()

    onString = not onString
    set = set .. currentChar

    if not onString and not onCallFunction or charIndex == lineLength then

        appendToken(tokenType["Identifier"])
        set = ""
    end
    lastEmpty = false
end

local function processOpenParentheses()

    openParentheses = openParentheses + 1
       
    if not onFunction then

        onCallFunction = true

        local sucess = pcall(function()
            appendToken(tokenType["Identifier"])
        end)

        if not sucess then
            error("RunTime Error", "'" .. set .. "' was not defined")
            return
        end

        set = ""
        lastEmpty = false

        return
    end

    appendToken(tokenType["Identifier"])
    set = ""
end

local function processCloseParentheses()

    openParentheses = openParentheses - 1
    if openParentheses == 0 then


        appendToken(tokenType["Call"])
        onCallFunction = false
        onFunction = false

        set = ""

    end

    lastEmpty = false
end

local function processEquals()

    if openParentheses == 0 then
 
       if not keywords[set] then
        
          if lastEmpty == false then
              appendToken(tokenType["Identifier"])
          end

          set = "="
          appendToken(tokenType["Equals"])
          set = ""
       end
    end
    lastEmpty = false
end

function processSpace()

    if openParentheses == 0 and not onString then

        if not keywords[set] then
            appendToken(tokenType["Identifier"])
        else
            appendToken(tokenType["Keyword"])

        end

        set = ""
        lastEmpty = true
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
        processEquals()
    
    elseif currentChar == " " and set:len() ~= 0 and not onString and not onCallFunction and not lastEmpty then
        processSpace()

    else

        if keywords[set .. currentChar] then

            set = set .. currentChar
            keywords[set]()
            return
        end

        if charIndex == lineLength then

            set = set .. currentChar
            appendToken(tokenType["Identifier"])
        elseif currentChar ~= " " or onString then

            set = set .. currentChar
        end
        lastEmpty = false
    end
end
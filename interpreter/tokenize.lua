require "interpreter/env"

local keywords = {
    ["function"] = true,
}

local function appendToken(type)

    table.insert(tokens[currentLine], {value = set, type = type, active = true})
end

local function processString()

    onString = not onString
    set = set .. currentChar

    if not onString and not onCallFunction or charIndex == lineLength then
        if not keywords[currentChar] then

            appendToken(tokenType["Identifier"])
            set = ""
        end
    end
    lastEmpty = false
end

local function processOpenParentheses()

    openParentheses = openParentheses + 1
       
    if openParentheses > 0 then
       onCallFunction = true
    end

    set = set:sub(1, -1)

    if _GLOBAL[set] then
       appendToken(tokenType["Identifier"])
    end
    set = ""
    lastEmpty = false
end

local function processCloseParentheses()

    openParentheses = openParentheses - 1
    if openParentheses == 0 then

       appendToken(tokenType["Call"])
       onCallFunction = false
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

    if currentChar == '"' or currentChar == "'" then
        processString()
    
    elseif currentChar == "(" then
        processOpenParentheses()
    
    elseif currentChar == ")" then
        processCloseParentheses()
    
    elseif currentChar == "=" then
        processEquals()
    
    elseif currentChar == " " and set:len() ~= 0 and not onString and not lastEmpty then
        processSpace()
    else

        if charIndex == lineLength then

            set = set .. currentChar
            appendToken(tokenType["Identifier"])
        elseif currentChar ~= " " or onString then

            set = set .. currentChar
        end
        lastEmpty = false
    end
end
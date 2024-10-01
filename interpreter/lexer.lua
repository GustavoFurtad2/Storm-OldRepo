require "interpreter/env"
require "interpreter/utils"
require "interpreter/parser"
require "interpreter/tokenize"

local function checkLine()

    if lineCode:match("^%s*%-%-") then
        return
    end

    for char, index in lineCode:gmatch("(.)()") do

        if crashed then
            break
        end

        currentChar = char
        charIndex = charIndex + 1
        tokenize()
        
    end

    if onCallFunction then

        error("Type Error", "')' expected to close call function at line " .. currentLine)
    elseif onString then
        
        error("Type Error", [[" or ' expected to close string at line ]] .. currentLine)   
    end

   if debug then

        local biggestSet = 1

        for i, token in next, tokens[currentLine] do

            local length = tostring(token.value):len()

            if length > biggestSet then

                biggestSet = length
            end
        end

        print(" NUMBER |  SET" .. string.rep(" ", biggestSet) .. "| TYPE   ")

        for i, token in next, tokens[currentLine] do

            print(string.format(
                        " %s| %s| %s", i .. string.rep(" ", 7 - tostring(i):len()),
                        token.value .. string.rep(" ", (4 + biggestSet) - tostring(token.value):len()),
                        token.type
            ))
        end
    end
end

function lexer(sourceCode)

    if sourceCode:len() > 0 then

        for line in string.gmatch(sourceCode, "[^\n]+") do
            table.insert(lines, line)
        end

        for index, line in next, lines do

            if crashed then
                break
            end

            currentLine   = index
            lineLength    = line:len()
            lineCode      = line
            tokens[index] = {}

            checkLine()
            parser()
        
        end

        if openScopes > 0 then

            error("Type Error", "'end' expected at line " .. currentLine)     
        end
    end
end

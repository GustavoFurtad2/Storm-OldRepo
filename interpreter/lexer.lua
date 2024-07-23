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
            error("Type Error", "'end' expected to close function")
        end
    end
end
require "parse"
require "util"

local LNUMBER
local SET = ""
local keywords = {
    [" "] = function()
        if LAST_IS_EMPTY == false then
            Interpreter[LNUMBER][#Interpreter[LNUMBER]+1] = SET
            SET = ""
            LAST_IS_EMPTY = true
        end
    end,
    ["("] = function()
        Interpreter[LNUMBER][#Interpreter[LNUMBER]+1] = SET
        SET = "("
        LAST_IS_EMPTY = false   
    end,
    [")"] = function()
        Interpreter[LNUMBER][#Interpreter[LNUMBER]+1] = SET .. ")"
        SET = ""
        LAST_IS_EMPTY = false
    end,
    ["="] = function()
        Interpreter[LNUMBER][#Interpreter[LNUMBER]+1] = SET .. "="
        SET = ""
    end
}

Lexer = function(code)

    local LINES = Lines(code)
    for NUMBER, LINE in next, LINES do
        
        if CRASHED == true then
            break
        else
            LNUMBER = NUMBER
            Interpreter[NUMBER] = {}
            SET = ""
            for C = 1, LINE:len() do
                local CHAR = LINE:sub(C,C)
                if CHAR == "/" and INSIDE_STRING == false then
                    break        
                elseif keywords[CHAR] and INSIDE_STRING == false then
                    keywords[CHAR]()
                elseif keywords[CHAR] == '"' or keywords[CHAR] == "'" then
                    SET = SET .. CHAR
                    INSIDE_STRING = not INSIDE_STRING
                else
                    SET = SET .. CHAR
                    if C == LINE:len() then
                        Interpreter[NUMBER][#Interpreter[NUMBER]+1] = SET
                        LAST_IS_EMPTY = false
                    end
                end
            end
            Parse.Read(Interpreter[LNUMBER], NUMBER)
        end
    end
end

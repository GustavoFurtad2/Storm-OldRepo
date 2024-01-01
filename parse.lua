require "util"
require "var"

local WORD, NEXTWORD, NEXT2WORD
Parse = {}

Parse.Read = function(CODE, LINE)
    local Row = {}
    for W = 1,#CODE do
        Row[W] = true
    end

    for k, v in next, Row do
        if v == true then
            WORD, NEXTWORD, NEXT2WORD = CODE[k] and CODE[k] or nil, CODE[k+1] and CODE[k+1] or nil, CODE[k+2] and CODE[k+2] or nil

            if NEXTWORD == "=" and NEXT2WORD ~= "nil" then
                Row[k + 1] = false
                Row[k + 2] = false
                Var.New(WORD, Var.AssignType("1"))
            elseif _All[WORD] and NEXTWORD:match("^(.*)$") then
                local args = Split(NEXTWORD:sub(2,-2), ",")
                for k, v in next, args do
                    if v:sub(1,1) == '"' and v:sub(-1) ~= '"' then
                        Error(line, "Init", '" expected to close string.')
                        break
                     end
                end
                _All[WORD](table.unpack(args))
                Row[k + 1] = false
            else
                Error(LINE, "Init Error", string.format('"%s" Unexpected.', WORD))
                break
            end
        end
    end
end

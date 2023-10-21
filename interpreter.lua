require "auxiliar"

local lexer = {}
local Interpreter = {}

local lines = {}

local fors = {}

Parse = function (line)

    local I = Interpreter[line]

    local order = {}
    for i = 1,#I.words do
       table.insert(order, {v=i, active = true})
    end

    for k, v in next, order do
       
       local word = I.words[v.v]
       local nword = ""
       local nnword = ""
       if v.active == true then 

        if I.words[v.v+1] then
                nword = tostring(I.words[v.v+1])
            end
            if I.words[v.v+2] then
                nnword = tostring(I.words[v.v+2])
            end
            
            
            if not Keywords[word] then
                if nword == "=" and not _w.vars[word] and nnword ~= "function" then
                
                    _w.vars[word] = {index = #_w.vars+1, type=AssignType(nnword, line), value = DisplayString(nnword)}
                    order[v.v + 1].active = false
                    order[v.v + 2].active = false
                elseif not _w.vars[word] and nnword ~= "=" and word ~= "" then
                    Error(line, "Init", string.format('"%s" not expected', word))
                    break
                else
                    if _w.vars[word] then
                        
                        
                        if string.match(nword, '^(.*)$') then
    
                            if _w.vars[word].type == "function" then
                                local args = Split(nword:sub(2,-2), ",")
                                for k, v in next, args do
                                   if v:sub(1,1) == '"' and v:sub(-1) ~= '"' then
                                      Error(line, "Init", '" expected to close string.')
                                      break
                                   end
                                end

                                _w.vars[word].value(args[1], args[3], args[3], args[4], args[5], args[6])
                                order[v.v + 1].active = false
                            else
                                Error(line, "Init Error", '"' .. word .. '" Inst a function.')          
                                break                  
                            end
                        end
                    end
                end

            else
                if word == "for" then
                    if string.match(nword, '^(.*)$') and nnword == "do" then
                        local args = Split(nword:sub(2,-2), ",")
                        
                    end
                end
            end
        end
    end

end

Lexer = function (file)
    
    local file = io.open(file, "r"):read("*a")

    lines = Lines(file)
    
    for k, v in next, lines do
      
        if BREAKED == true then
            break
        end
        Interpreter[k] = {insideString = false,insideFunc = false,openParentheses = 0,words = {}}

        local lastIsEmpty = false
        
        local I = Interpreter[k]

        local conjunto = ""
        
        for c = 1,v:len() do

          if v:sub(c,c+1) == "--" then
            break
          else
            if (v:sub(c,c) == " " or v:sub(c,c) == "(" or v:sub(c,c) == ")" or v:sub(c,c) == "=") and I.insideString == false then

                if v:sub(c,c) == " " then
                    if lastIsEmpty == false then
                      I.words[#I.words+1] = conjunto
                      conjunto = ""
                      lastIsEmpty = true
                    end
                elseif v:sub(c,c) == "(" then
                    I.words[#I.words+1] = conjunto
                    conjunto = "("                    
                    lastIsEmpty = false
                elseif v:sub(c,c) == ")" then       
                    I.words[#I.words+1] = conjunto .. ")"      
                    conjunto = ""     
                    lastIsEmpty = false
                elseif v:sub(c,c) == "=" then
                    I.words[#I.words+1] = conjunto .. "="
                    conjunto = ""
                end
            elseif (v:sub(c,c) ~= " " or v:sub(c,c) ~= "(" or v:sub(c,c) ~= ")" or v:sub(c,c) ~= "=") then
            

               conjunto = conjunto .. v:sub(c,c)
               if v:sub(c,c) == '"' then
                   I.insideString = not I.insideString
                   lastIsEmpty = false
               end
               if c == v:len() then
                  I.words[#I.words+1] = conjunto
                  lastIsEmpty = false
               end
            end
          end
        end
        
        Parse(k)
    end
end

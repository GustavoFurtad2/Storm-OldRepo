require "interpreter"
require "utils"

local Token0, Token1, Token2

local function CallFunction()
    
    local args = Split(Token1.Token, ",")
    Token1.Active = false

    for i in next, args do
        args[i] = ToValue(args[i])
    end

    _A[Token0.Token](table.unpack(args))
end

local function MakeValue(name, value)

    if tonumber(name:sub(1,1)) ~= nil then
        Error("Init Error", "Variables can't start with numbers")
        return
    end
    Token1.Active = false
    Token2.Active = false
    _A[Token0.Token] = value
end

local function TryMakeVariable()

    if Token2 ~= nil then

         if Token2.Type == TokenType.Identifier then

            MakeValue(Token0.Token, ToValue(Token2.Token))
         end
     else

    end
end

function Parser(tokens)

    for i, token in next, tokens do
        
        if token.Active == true then

           Token0 = token
           Token1 = tokens[i + 1]
           Token2 = tokens[i + 2]

           if Crashed == false then
               if token.Type == TokenType.Identifier then

                    if Token1 ~= nil then

                        if Token1.Type == TokenType.Call then

                            CallFunction()
                        elseif Token1.Type == TokenType.Keyword and Token1.Token == "=" then

                            TryMakeVariable()

                        else
                       
                            Error("Init Error", string.format("Unexpected '%s'", token.Token))
                            break
                        end
                    else
                        Error("Init Error", string.format("Unexpected '%s'", token.Token))                        
                    end
                end
           else
               break
           end
        end
    end
end
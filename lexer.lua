require "interpreter"
require "parser"
require "utils"

local LINES = {}
local Set = ""

local SplitChars = {["("] = true}
local EndChars = {[")"] = true}
local Keywords = {}

local function AppendToken(Set, Type, Parameters)

   local Token = {Token = Set, Type = Type, Index = #Tokens[Line] + 1, Active = true}
   if Parameters then
      Token.Parameters = Parameters
   end

   table.insert(Tokens[Line], Token)
end

local function ShowTokens()
   local biggestSet = 1

   for i, t in next, Tokens[Line] do
      local length = tostring(t.Token):len()
      if length > biggestSet then
         biggestSet = length
      end
   end

   print(" NUMBER |  SET" .. string.rep(" ", biggestSet) .. "| TYPE   ")

   for i, t in next, Tokens[Line] do
      print(string.format(" %s| %s| %s",
        i .. string.rep(" ", 7 - tostring(i):len()),
        t.Token .. string.rep(" ", (4 + biggestSet) - tostring(t.Token):len()),
        t.Type)
      )
   end
end

local function SetChar(index, char, lineLength)

   if char == '"' or char == "'" then
       OnString = not OnString

       Set = Set .. char
       if OnString == false and OnCall == false then
          if not Keywords[Set] then
             AppendToken(Set, TokenType.Identifier)
             Set = ""
          end
       end

   elseif char == "(" then
       OpenParentheses = OpenParentheses + 1
       
       if OpenParentheses > 0 then
          OnCall = true
       end

       if _A[Set] then
          AppendToken(Set, TokenType.Identifier)
       end
       Set = ""

   elseif char == ")" then
      
       OpenParentheses = OpenParentheses - 1
       if OpenParentheses == 0 then
          AppendToken(Set, TokenType.Call)
          OnCall = false
          Set = ""
       end

   elseif char == "=" then

       if OpenParentheses == 0 then

         if not Keywords[Set] then
            if Set:len() ~= 0 then
               AppendToken(Set, TokenType.Identifier)
            end

            AppendToken("=", TokenType.Keyword)
            Set = ""
         end
      end

   elseif char == " " and Set:len() ~= 0 and OnString == false then

      if OpenParentheses == 0 and OnString == false then

         if not Keywords[Set] then
            AppendToken(Set, TokenType.Identifier)
         else
            AppendToken(Set, TokenType.Keyword)
         end
         Set = ""
      end
   else
       if index == lineLength then
          Set = Set .. char
          AppendToken(Set, TokenType.Identifier)
       elseif char ~= " " or OnString == true then
          Set = Set .. char
       end
   end
end

local function CheckLine(code, lineLength)

   for Chars = 1, lineLength do
                
      if Crashed == true then
         break
      else
          local Char = code:sub(Chars, Chars)
          if code:sub(Chars, Chars + 1) == "--" then
             break
          else
             SetChar(Chars, Char, lineLength)
          end
      end
   end
end

function Lexer(sourceCode)
    if sourceCode:len() > 0 then
       
       for line in string.gmatch(sourceCode, "[^\n]+") do
          table.insert(LINES, line)
       end

       for index, line in next, LINES do

         if Crashed == true then
             break
         else
             Line = index
             Tokens[Line] = {}
             
             CheckLine(line, line:len())
             --ShowTokens()
             Parser(Tokens[Line])
          end
       end
    end
end

_A["Dofile"] = function(fileName)

   local file = io.open(fileName, "r")
   if file ~= nil and fileName:sub(-3) == ".st" then
       Lexer(file:read("*a"))
   end
end

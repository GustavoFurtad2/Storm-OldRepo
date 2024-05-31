require "interpreter"
require "parser"
require "utils"

local LINES = {}
local Set = ""

local SplitChars = {["("] = true}
local EndChars = {[")"] = true}
local Keywords = {["function"] = true}

local function AppendToken(Set, Type, Parameters)

   local Token = {Token = Set, Type = Type, Index = #Tokens[Line] + 1, Active = true}
   if Parameters then
      Token.Parameters = Parameters
   end

   table.insert(Tokens[Line], Token)
end

local function processQuotes(char)

   OnString = not OnString

   Set = Set .. char
   if OnString == false and OnCall == false then
      if not Keywords[Set] then
         AppendToken(Set, TokenType.Identifier)
         Set = ""
      end
   end
   LastEmpty = false
end

local function processOpenParentheses()
    OpenParentheses = OpenParentheses + 1
       
    if OpenParentheses > 0 then
       OnCall = true
    end

    if _A[Set] then
       AppendToken(Set, TokenType.Identifier)
    end
    Set = ""
    LastEmpty = false
end

local function processCloseParentheses()

   OpenParentheses = OpenParentheses - 1
   if OpenParentheses == 0 then
      AppendToken(Set, TokenType.Call)
      OnCall = false
      Set = ""
   end
   LastEmpty = false
end

local function processEqual()

   if OpenParentheses == 0 then

      if not Keywords[Set] then
         if Set:len() ~= 0 then
            AppendToken(Set, TokenType.Identifier)
         end

         AppendToken("=", TokenType.Keyword)
         Set = ""
      end
   end
   LastEmpty = false
end

local function processSpace()

   if OpenParentheses == 0 and OnString == false then

      if not Keywords[Set] then
         AppendToken(Set, TokenType.Identifier)
      else
         AppendToken(Set, TokenType.Keyword)
         --[[
         if (Set == "function") then
            OnFunction = true
            OpenFunctions = OpenFunctions + 1
         end]]
      end
      Set = ""

      LastEmpty = true
   end
end

local function processOtherCharacter(char, index, lineLength)

   if index == lineLength then
      Set = Set .. char
      AppendToken(Set, TokenType.Identifier)
   elseif char ~= " " or OnString == true then
      Set = Set .. char
   end
   LastEmpty = false
end

local function SetChar(index, char, lineLength)

   if char == '"' or char == "'" then
       
       processQuotes(char)
   elseif char == "(" then
       
       processOpenParentheses()
   elseif char == ")" then
      
       processCloseParentheses()
   elseif char == "=" then

       processEqual()
   elseif char == " " and Set:len() ~= 0 and OnString == false and LastEmpty == false then

       processSpace()
   else

       processOtherCharacter(char, index, lineLength)
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
             --ShowTokens() mostra os tokens e seus respectivos tipos
             Parser(Tokens[Line])
          end
       end
    end
end

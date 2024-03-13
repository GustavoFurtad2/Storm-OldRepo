require "interpreter"

function Error(ErrorType, Message)
   Crashed = true
   print(string.format("%s Error at line %s: %s", ErrorType, Line, Message))
end

function ToValue(value)
   
   if string.match(value, [[^["'].-["']$]]) then

      return value:sub(2, -2)
   elseif value == "true" then
      return true

   elseif value == "false" then
      return false

   elseif tonumber(value) ~= nil then

      return tonumber(value)
   elseif _A[value] then

      return _A[value]
   elseif string.match(value, [[^["'].-["']$]]) then
      
      Error("Lexer", "Unfinished string")
   else
      return nil
   end
end

function Split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
      table.insert(result, match)
    end
    return result
end
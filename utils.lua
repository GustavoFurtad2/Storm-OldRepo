require "interpreter"

function Error(ErrorType, Message)
   Crashed = true
   print(string.format("%s Error at line %s: %s", ErrorType, Line, Message))
end

function ToValue(value)
   
   if string.match(value, "[+%-*/]") or string.match(value, "%.%.") then

      return load("return " .. value, nil, nil, _A)()
   elseif string.match(value, [[^["'].-["']$]]) then

      return value:sub(2, -2)

   elseif value == "true" then

      return true

   elseif value == "false" then

      return false

   elseif tonumber(value) ~= nil then

      return tonumber(value)

   elseif _A[value] then

      return _A[value]

   elseif not value:match("^[\"'].-[\"']$") then
      
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

function ShowTokens()
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

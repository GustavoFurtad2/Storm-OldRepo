require "interpreter"

function ToArg(arg)
   
   if string.match(arg, [[^".*"$]]) or string.match(arg, [[^'.*'$]]) then
      return arg:sub(2, -2)
   elseif arg == "true" then
      return true
   elseif arg == "false" then
      return false
   elseif tonumber(arg) ~= nil then
      return tonumber(arg)
   elseif _A[arg] then
      return _A[arg]
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
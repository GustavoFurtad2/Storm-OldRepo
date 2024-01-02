require "interpreter"

getOS = function()
  return package.config:sub(1,1) == "\\" and "Windows" or "Linux"
end

Lines = function(string) -- Pega cada linha distribuindo em uma tabela
    local lines = {}
    for line in string.gmatch(string,'[^\n]+') do
      table.insert(lines,line)
    end

    return lines
end

Split = function (s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

Error = function(line, error_type, message)
   CRASHED = true
   print("Storm " .. line .. ": " .. error_type .. " " .. message)
end

FormatString = function(msg)
  local m = msg
  if string.match(msg, '^".*"$') or string.match(msg, "^'.*'$") then
     m = msg:sub(2,-2)
  elseif _All[msg] then
     m = _All[msg]
  end
  return m
end

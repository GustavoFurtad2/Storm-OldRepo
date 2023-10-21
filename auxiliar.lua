_w = {vars={}}

BREAKED = false

_w.vars.write = {
    index = 1,
    type = "function",
    value = function (s)
        print(DisplayString(s))
    end
}

_w.vars.Run = {
   index = 2,
   type = "function",
   value = function(s)
      Run(s)
   end
}

Keywords = {
   ["for"] = true,
}

Lines = function(string) -- Pega cada linha distribuindo em uma tabela

    local lines={}
    for line in string.gmatch(string,'[^\n]+') do
      table.insert(lines,line)
    end
    
    return lines
end


Error = function (line, type, message)
   print("Uranus: " .. line .. " " .. type .. " error " .. message .. "\n")
   BREAKED = true
end

Split = function (s, delimiter)
  local result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

DisplayString = function (string)
  
   local str = nil
   local string = tostring(string)
   if string:sub(1,1) == '"' and string:sub(-1) == '"' then
      str = string:sub(2,-2)
   elseif _w.vars[string] then
      str = _w.vars[string].value
   end
  return str
end

AssignType = function (str, line)
  
   local type = nil

   if str:sub(1,1) == '"' and str:sub(-1) == '"' then
      type = "string"
   elseif str:sub(1,1) ~= '"' and str:sub(-1) ~= '"' and tonumber(str) ~= nil  then
      type = "number"
   elseif str:sub(1,1) == '"' and str:sub(-1) ~= '"' then
      Error(line, "Init", '" expected to close string.')
   elseif _w.vars[str] then
      type = _w.vars[str].type
   end
   return type
end

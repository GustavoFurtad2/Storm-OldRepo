function isAlpha(s)
    return s:lower() ~= s:upper()
end

function isNumber(s)
    return tonumber(s) ~= nil
end

function split(s, delimiter)

    local result = {}

    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end

    return result
end

function toValue(value)
   
    if string.match(value, "[+%-*/]") or string.match(value, "%.%.") then
 
       return load("return " .. value, nil, nil, _GLOBAL)()
    elseif string.match(value, [[^["'].-["']$]]) then
 
       return value:sub(2, -2)
 
    elseif value == "true" then
 
       return true
 
    elseif value == "false" then
 
       return false
 
    elseif tonumber(value) ~= nil then
 
       return tonumber(value)
 
    elseif _GLOBAL[value] then
 
       return _GLOBAL[value]
 
    elseif not value:match("^[\"'].-[\"']$") then
        
    else
       return nil
    end
end
-- Funções Auxiliares
NoSpace = function (str) -- Tira Espaço de uma string
    local novaString = ""
    for i = 1,str:len() do
       if str:sub(i,i) ~= " " then
         novaString = novaString .. str:sub(i,i)
       end
    end
    return novaString
end

Lines = function(string) -- Pega cada linha distribuindo em uma tabela

  local lines={}
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

Error = function (line, tipo, motivo)
   print("Uranus " .. tipo .. " error line " .. line .. ":"..motivo)
end

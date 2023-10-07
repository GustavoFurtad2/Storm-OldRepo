local read={
	lines=function(string)
		string=string:gsub('<br>','\n'):gsub('</br>','')
		local lines={}
		for line in string.gmatch(string,'[^\n]+') do
			table.insert(lines,line)
		end
		
		return lines
	end,
}

local _world = {
    E = function (str) -- Tira Espaço de uma string
        local novaString = ""
        for i = 1,str:len() do
           if str:sub(i,i) ~= " " then
             novaString = novaString .. str:sub(i,i)
           end
        end
        return novaString
    end,

    split = function (s, delimiter)
      local result = {}
      for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
      end
      return result
    end,

    error = function (line, tipo, motivo)
       print("Uranus " .. tipo .. " error line " .. line .. ":"..motivo)
    end,
    
    functions = {
        write = {
             index = 1,
             exec = function(str)
                print(str)
             end
        },
    },
    variables = {}
}

local Run = function (content)
    local content = love.filesystem.read(content)

    local linhas = read.lines(content)
    local error = false

    local interpreter = {}
    for i = 1,#linhas do
       local linha = linhas[i]
       interpreter[i] = {
         inFunc=false,
         started=false,
         args={},
         funcIndex = nil,
         annotation = false,
         finished=false
       }
       
       local int = interpreter[i]
       for l = 1,linha:len() do
           for c = 1,linha:len() do
             if int.annotation == false then
              if int.inFunc == false and _world.functions[linha:sub(c,l)] then -- Checando uma função
                int.inFunc = true
                int.funcIndex = _world.functions[linha:sub(c,l)].index

              elseif int.inFunc == true and linha:sub(c,l) == "(" and int.started == false then -- Começando uma função
                int.started = true

              elseif int.inFunc == true and linha:sub(c,l) == ")" and int.started == true  then -- Finalizando uma função
                int.finished = true
              elseif int.inFunc == true and int.started == true and int.finished == false and linha:sub(c,c) == "(" and linha:sub(l,l) == ")" and linha:sub(l,l+1) ~= ")," then 
                -- argumentos
                int.args = _world.split(linha:sub(c+1,l-1), ",")
                for k, v in next, _world.functions do
                    if v.index == int.funcIndex then
                       v.exec(int.args[1])
                       break
                    end
                end
                int.inFunc = false
                int.started = false
                int.ended = false
              elseif linha:sub(c,l) == "--" then
                int.annotation = true
                break
              end
 
              end
           end
       end
       -- acha erro
       if int.inFunc == true and int.finished == false then
          _world.error(i, "Init Error", [[")" expected to close function]])
          error = true
       end
       if error == true then
        break
     end
    end
end

Run("main.uranus")

require "auxiliar"

local _world = {

    functions = {
        write = {
             index = 1,
             exec = function(str)            
                print(str)
             end
        },
    },

    fors = {},
    variables = {}
}

local lexer = function (file)

    local interpreter = {}
    local lines = Lines(file)

    for l = 1,#lines do

        interpreter[l] = {
           inFunc = false, started = false, args = {}, funcIndex = nil, anottation = false, finished = false,
           fors = {}
        }
        local linha = lines[l]
        local int = interpreter[l]
        
        for t = 1,linha:len() do
           for c = 1, linha:len() do
              
              if int.anottation == false then
                 
                 if linha:sub(c,t) == "--" then
                    int.anottation = true
                    break
                 end
                 if int.inFunc == false then
                    
                     if _world.functions[linha:sub(c,t)] then -- Entrando em função
                        int.inFunc = true
                        int.funcIndex = _world.functions[linha:sub(c,t)].index
                     end
                 elseif int.inFunc == true then
                    
                     if int.started == false then
                      
                        if linha:sub(c,c) == "(" then
                           int.started = true
                        end

                      elseif int.started == true then
                        
                        if linha:sub(t,t) == ")" and int.finished == false then
                           int.finished = true

                        elseif linha:sub(c,c) == "(" and linha:sub(t,t) == ")" then

                           int.args = Split(linha:sub(c+1,t-1), ",")
                           for k, v in next, _world.functions do
                               if v.index == int.funcIndex then

                                local ended = true
                                local index

                                for k, v in next, _world.fors do
                                   if v.ended == false then
                                      ended = false
                                      index = k
                                      break
                                   end
                                end
                                
                                if ended == true then
                                   v.exec(int.args[1], int.args[2], int.args[3])
                                else
                                   for i = _world.fors[index].ns, _world.fors[index].nf do
                                      v.exec(int.args[1], int.args[2], int.args[3])
                                   end
                                end
                                int.inFunc = false
                                int.started = false
                                int.finished = false
                                int.args = {}
                                break
                              end
                           end
                        end
                     end
                 end
              end
           end
        end
    end
end

local Run = function (file)
 
    local file = io.open(file, "r")
    local content = file:read()

    lexer(content)
end

Run("teste/main.uranus")

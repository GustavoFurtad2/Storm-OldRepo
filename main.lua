require "Interpreter"

Run = function (file)    
    Lexer(file)
end 

Run("main.lazuli")

require "lexer"
require "math"
require "var"

os.execute(string.format("title %s", "Storm"))

local Run = function(code)
    Lexer(code)
end

Var.New("dofile", function (file)
    if io.open(file) and file:sub(-3) == ".st" then
        Run(io.open(file, "r"):read("*a"))
    end
end)

Run(io.read())

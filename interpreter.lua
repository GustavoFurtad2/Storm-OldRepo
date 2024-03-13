Crashed    = false
OnCall     = false
OnString   = false
OnFunction = false
LastEmpty  = false

OpenParentheses = 0
OpenFunctions = 0

Tokens = {}
Line = 1

TokenType = {
    ["Identifier"] = 0,
    ["Keyword"] = 1,
    ["Call"] = 2,
}

_A = {
    VERSION = "0.1.0",
    OS = package.config:sub(1,1) == "\\" and "Windows" or "Linux",
    print = function(message)
        if Crashed == false then
            print(message)
        end
    end,

    execute = function(command)
        os.execute(command)
    end,
}

local A = _A

function Reset()
    Crashed, OnCall, OnString, OnFunction, LastEmpty = false, false, false, false, false
    OpenParentheses, OpenFunctions, Line = 0, 0, 1
    Tokens = {}
    _A = A
end
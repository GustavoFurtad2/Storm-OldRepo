Crashed    = false
OnCall     = false
OnString   = false
OnFunction = false
LastEmpty  = false

OpenParentheses = 0

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
        print(message)
    end,
}
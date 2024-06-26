onCallFunction  = false
onFunction      = false
onString        = false
lastEmpty       = false
crashed         = false

currentChar     = nil
lineLength      = nil
lineCode        = nil

openParentheses = 0
charIndex       = 0

set = ""

tokens, lines, currentLine = {}, {}, 1

tokenType = {
    ["Identifier"] = 1,
    ["Keyword"]    = 2,
    ["Equals"]     = 3,
    ["Call"]       = 4,
}

_GLOBAL = {
    _VERSION = "0.1.0",
    _OS = package.config:sub(1,1) == "\\" and "Windows" or "Linux",
    _CPATH = arg[0],

    print = function(s)
        print(s)
    end
}

onCallFunction  = false
onFunction      = false
onString        = false
onScope         = false
lastEmpty       = false
crashed         = false

currentChar     = nil
lineLength      = nil
lineCode        = nil

openParentheses = 0
openScopes      = 0
charIndex       = 0

set = ""

currentToken, nextToken, nextNextToken, nextNextNextToken = nil, nil, nil, nil
tokens, scopes, lines, currentLine, currentScope = {}, {}, {}, 1, nil

tokenType = {
    ["Identifier"] = 1,
    ["Function"]   = 2,
    ["Keyword"]    = 3,
    ["Equals"]     = 4,
    ["Call"]       = 5,
    ["End"]        = 6,
}

_GLOBAL = {
    _VERSION = "0.1.0",
    _OS = package.config:sub(1,1) == "\\" and "Windows" or "Linux",
    _CPATH = arg[0],

    print = function(output)
        print(output)
    end,

    getTime = function()
        return os.time()
    end,
}
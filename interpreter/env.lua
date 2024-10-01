debug = false

onCallFunction = false
onFunction = false
onString = false
onScope = false
lastSpace = false
crashed = false

lineLength = 0
lineCode = ""

charIndex = 0
currentLine = 1

currentChar = nil
currentToken = nil

nextToken = nil
nextNextToken = nil
nextNextNextToken = nil

lines = {}
scopes = {}

openParentheses = 0
openScopes = 0

currentScope = nil

tokens = {}
tokenSet = ""

tokenType = {
    ["identifier"] = 1,
    ["function"]   = 2,
    ["assign"]     = 3,
    ["args"]       = 4,
    ["end"]        = 5
}

_GLOBAL = {
    _VERSION = "0.1.0",
    _CPATH = arg[0],
    _OS = package.config:sub(1,1) == "\\" and "Windows" or "Linux",
}

_GLOBAL.print = function(output)

    print(output)
end

_GLOBAL.read = function()

    return io.read()
end

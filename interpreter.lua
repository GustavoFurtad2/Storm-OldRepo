CRASHED = false
INSIDE_CALL = false
INSIDE_STRING = false
INSIDE_FUNCTION = false
LAST_IS_EMPTY = false
OPENPARENTHESES = 0

Interpreter = {}
_All = {["VERSION"] = "0.1.0", ["OS"] = package.config:sub(1,1) == "\\" and "Windows" or "Linux"}

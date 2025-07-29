require "interpreter/env"
require "interpreter/lexer"

local getFilesCommand = _GLOBAL._OS == "Windows" and "dir /b" or "ls"

local function loadStandartLibs()

    local files = io.popen("cd stdlibs && " .. getFilesCommand):lines()

    for fileName in files do

        require("stdlibs/" .. fileName:sub(1, fileName:len() - 4))
    end
end

loadStandartLibs()

os.execute("title Storm " .. _GLOBAL._VERSION)
print("Storm " .. _GLOBAL._VERSION .. " - https://github.com/GustavoFurtad2/Storm-OldRepo")

lexer(io.read())

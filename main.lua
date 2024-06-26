require "interpreter/env"
require "interpreter/lexer"

os.execute "title Storm"
print("Storm " .. _GLOBAL._VERSION .. " - https://github.com/GustavoFurtad2/Storm")

lexer(io.read())
require "interpreter"
require "lexer"

os.execute "title Storm"
print(string.format("[Storm %s - 2024] - https://github.com/GustavoFurtad2/Storm", _A.VERSION))

Lexer(io.read())
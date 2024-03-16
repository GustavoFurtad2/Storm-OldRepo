require "interpreter"
require "lexer"

os.execute "title Storm"
print(string.format("[Storm %s - 2024] - https://github.com/GustavoFurtad2/Storm", _A._VERSION))

Lexer(io.read())

require "interpreter/env"

_GLOBAL.io = {

    read = function()

        return io.read()
    end
}

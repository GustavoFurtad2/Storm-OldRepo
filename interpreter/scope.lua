require "interpreter/env"

function scope(name)

    local scope = {
        name = name,
        instructions = {},
    }

    openScopes = openScopes + 1
    onScope    = true

    function scope:newInstruction(instruction)

        table.insert(self.instructions, {instruction = instruction, coroutine = coroutine.create(instruction)})
    end

    function scope:execute()
        
        for k, v in next, self.instructions do
            coroutine.resume(v.coroutine)
            v.coroutine = coroutine.create(v.instruction)
        end
    end

    return scope
end
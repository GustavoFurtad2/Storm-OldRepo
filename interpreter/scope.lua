require "interpreter/env"

Scope = {}
Scope.__index = Scope

function Scope:new(name)

    local scope = setmetatable(
        {
            name = name,
            instructions = {}
        },
    Scope)

    openScopes = openScopes + 1
    onScope = true

    return scope
end

function Scope:newInstruction(instruction)

    table.insert(self.instructions, instruction)
end

function Scope:execute()

    for i, instruction in next, self.instructions do

        instruction()
    end
end

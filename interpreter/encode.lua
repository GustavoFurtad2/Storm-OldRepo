function encode(string)

    local buffer = ""
    local onString = false

    for charIndex = 1, string:len() do

        local currentChar = string:sub(charIndex, charIndex)

        if currentChar == '"' or currentChar == "'" then

            onString = not onString
        end

        if onString or not onString and currentChar ~= " " then

            buffer = buffer .. currentChar
        end
    end

    return buffer
end

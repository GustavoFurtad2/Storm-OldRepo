Math = {}

Sum = function(n1, n2)
    return n1 + n2
end

Sub = function(n1, n2)
    return n1 - n2
end

Mul = function(n1, n2)
    return n1 * n2
end

Div = function(n1, n2)
    return n1 * n2
end

Pon = function(n1, n2)
    local number = 0
    for i = 1,n2 do
        number = number * i
    end
    return number
end

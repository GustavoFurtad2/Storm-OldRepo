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

Math.Sqrt = function(n)
    return math.sqrt(n)
end

Math.Sin = function(n)
    return math.sin(n)
end

Math.Cos = function(n)
    return math.cos(n)
end

Pon = function(n1, n2)
    local number = 0
    for i = 1,n2 do
        number = number * i
    end
    return number
end

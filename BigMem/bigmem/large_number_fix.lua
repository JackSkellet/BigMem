local LargeNumberFix = {}
local memoizationCache = {}

-- Memoization function
local function memoize(func)
    return function(...)
        local args = {...}
        local key = table.concat(args, ",")
        if not memoizationCache[key] then
            memoizationCache[key] = func(...)
        end
        return memoizationCache[key]
    end
end

LargeNumberFix.formatNumber = memoize(function(num)
    if num >= 1e100 then
        return string.format("%.2e", num)
    else
        return tostring(num)
    end
end)

function LargeNumberFix.add(a, b)
    return a + b
end

function LargeNumberFix.subtract(a, b)
    return a - b
end

function LargeNumberFix.multiply(a, b)
    return a * b
end

function LargeNumberFix.divide(a, b)
    if b == 0 then
        return math.huge
    else
        return a / b
    end
end

-- Additional functions for handling large numbers
function LargeNumberFix.power(a, b)
    return a ^ b
end

function LargeNumberFix.log(a, base)
    base = base or 10
    return math.log(a) / math.log(base)
end

function LargeNumberFix.exp(a)
    return math.exp(a)
end

-- Omega number function for extremely large numbers
LargeNumberFix.omegaNum = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = LargeNumberFix.power(a, result)
    end
    return result
end)

-- Function to handle large comparisons
function LargeNumberFix.compare(a, b)
    if type(a) == "table" then
        a = a[1] -- or some other appropriate value
    end
    if type(b) == "table" then
        b = b[1] -- or some other appropriate value
    end
    return a > b
end

-- Function to handle large number equality
function LargeNumberFix.equals(a, b)
    if type(a) == "table" then
        a = a[1] -- or some other appropriate value
    end
    if type(b) == "table" then
        b = b[1] -- or some other appropriate value
    end
    return a == b
end

-- Function to handle large number minimum
function LargeNumberFix.min(a, b)
    if type(a) == "table" then
        a = a[1] -- or some other appropriate value
    end
    if type(b) == "table" then
        b = b[1] -- or some other appropriate value
    end
    return math.min(a, b)
end

-- Function to handle large number maximum
function LargeNumberFix.max(a, b)
    if type(a) == "table" then
        a = a[1] -- or some other appropriate value
    end
    if type(b) == "table" then
        b = b[1] -- or some other appropriate value
    end
    return math.max(a, b)
end

return LargeNumberFix
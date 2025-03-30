local mathopt = {}

print("[BigMem] Applying optimized math system (with toggles, batching, tetration, etc.)")

-- Store original math functions
mathopt.original_log10 = math.log10
mathopt.original_exp = math.exp
mathopt.original_sqrt = math.sqrt
mathopt.original_cos = math.cos
mathopt.original_tan = math.tan
mathopt.original_pow = math.pow
mathopt.original_sin = math.sin

local memoizationCache = {}
local precomputedTrig = {}
local batchQueue = {}
local batchingEnabled = false

-- Memoization
local function memoize(func)
    local cache = {}
    return function(...)
        local args = {...}
        local key = table.concat(args, ",")
        if not cache[key] then
            cache[key] = func(...)
        end
        return cache[key]
    end
end

-- Precompute trig table
local function precomputeTrig()
    for i = 0, 360 do
        local rad = math.rad(i)
        precomputedTrig[i] = {sin = math.sin(rad), cos = math.cos(rad), tan = math.tan(rad)}
    end
    print("[BigMem] Precomputed trigonometric values")
end

-- Fast math implementations
mathopt.fast_log10 = function(x) return math.log(x) * 0.4342944819 end
mathopt.fast_pow = function(a, b) return math.exp(b * math.log(a)) end
mathopt.fast_cos = function(x) local x2 = x * x return 1 - x2 / 2 + x2 * x2 / 24 end
mathopt.fast_tan = function(x) local x2 = x * x return x + x2 * x / 3 + x2 * x2 * x / 5 end
mathopt.fast_sin = function(x) local x2 = x * x return x - x2 * x / 6 + x2 * x2 * x / 120 end
mathopt.fast_log2 = function(x) return math.log(x) / math.log(2) end
mathopt.fast_ln = function(x) return math.log(x) end

mathopt.fast_sqrt = function(x)
    local guess = x / 2
    for i = 1, 5 do
        guess = (guess + x / guess) / 2
    end
    return guess
end

mathopt.fast_factorial = memoize(function(n)
    if n == 0 then return 1 end
    return mathopt.fast_sqrt(2 * math.pi * n) * (n / math.exp(1)) ^ n
end)

mathopt.fast_gamma = memoize(function(z)
    local g = 7
    local p = {
        0.99999999999980993, 676.5203681218851, -1259.1392167224028,
        771.32342877765313, -176.61502916214059, 12.507343278686905,
        -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7
    }
    if z < 0.5 then
        return math.pi / (math.sin(math.pi * z) * mathopt.fast_gamma(1 - z))
    else
        z = z - 1
        local x = p[1]
        for i = 2, g + 2 do x = x + p[i] / (z + i - 1) end
        local t = z + g + 0.5
        return mathopt.fast_sqrt(2 * math.pi) * t ^ (z + 0.5) * math.exp(-t) * x
    end
end)

mathopt.fast_fibonacci = memoize(function(n)
    local phi = (1 + mathopt.fast_sqrt(5)) / 2
    return math.floor((phi ^ n - (-phi) ^ (-n)) / mathopt.fast_sqrt(5) + 0.5)
end)

mathopt.fast_binomial = memoize(function(n, k)
    if k > n then return 0 end
    if k == 0 or k == n then return 1 end
    return mathopt.fast_factorial(n) / (mathopt.fast_factorial(k) * mathopt.fast_factorial(n - k))
end)

mathopt.tetration = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do result = mathopt.fast_pow(a, result) end
    return result
end)

mathopt.pentation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do result = mathopt.tetration(a, result) end
    return result
end)

mathopt.hexation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do result = mathopt.pentation(a, result) end
    return result
end)

mathopt.heptation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do result = mathopt.hexation(a, result) end
    return result
end)

mathopt.octation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do result = mathopt.heptation(a, result) end
    return result
end)


mathopt.enableDisableMap = {
    fastPow = {
        enable = function() print("[BigMem] Enabling pow") math.pow = mathopt.fast_pow end,
        disable = function() print("[BigMem] Disabling pow") math.pow = mathopt.original_pow end,
    },
    fastLog10 = {
        enable = function() print("[BigMem] Enabling log10") math.log10 = mathopt.fast_log10 end,
        disable = function() print("[BigMem] Disabling log10") math.log10 = mathopt.original_log10 end,
    },
    fastFactorial = {
        enable = function() print("[BigMem] Enabling factorial") math.factorial = mathopt.fast_factorial end,
        disable = function() print("[BigMem] Disabling factorial") math.factorial = nil end,
    },
    fastGamma = {
        enable = function() print("[BigMem] Enabling gamma") math.gamma = mathopt.fast_gamma end,
        disable = function() print("[BigMem] Disabling gamma") math.gamma = nil end,
    },
    fastLn = {
        enable = function() print("[BigMem] Enabling ln") math.ln = mathopt.fast_ln end,
        disable = function() print("[BigMem] Disabling ln") math.ln = nil end,
    },
    fastLog2 = {
        enable = function() print("[BigMem] Enabling log2") math.log2 = mathopt.fast_log2 end,
        disable = function() print("[BigMem] Disabling log2") math.log2 = nil end,
    },
    fastCos = {
        enable = function() print("[BigMem] Enabling cos") math.cos = mathopt.fast_cos end,
        disable = function() print("[BigMem] Disabling cos") math.cos = mathopt.original_cos end,
    },
    fastSin = {
        enable = function() print("[BigMem] Enabling sin") math.sin = mathopt.fast_sin end,
        disable = function() print("[BigMem] Disabling sin") math.sin = mathopt.original_sin end,
    },
    fastTan = {
        enable = function() print("[BigMem] Enabling tan") math.tan = mathopt.fast_tan end,
        disable = function() print("[BigMem] Disabling tan") math.tan = mathopt.original_tan end,
    },
    tetration = {
        enable = function() print("[BigMem] Enabling tetration") math.tetration = mathopt.tetration end,
        disable = function() print("[BigMem] Disabling tetration") math.tetration = nil end,
    },
    pentation = {
        enable = function() print("[BigMem] Enabling pentation") math.pentation = mathopt.pentation end,
        disable = function() print("[BigMem] Disabling pentation") math.pentation = nil end,
    },
    hexation = {
        enable = function() print("[BigMem] Enabling hexation") math.hexation = mathopt.hexation end,
        disable = function() print("[BigMem] Disabling hexation") math.hexation = nil end,
    },
    heptation = {
        enable = function() print("[BigMem] Enabling heptation") math.heptation = mathopt.heptation end,
        disable = function() print("[BigMem] Disabling heptation") math.heptation = nil end,
    },
    octation = {
        enable = function() print("[BigMem] Enabling octation") math.octation = mathopt.octation end,
        disable = function() print("[BigMem] Disabling octation") math.octation = nil end,
    },
    precomputedTrig = {
        enable = function()
            print("[BigMem] Enabling precomputed trigonometry")
            precomputeTrig()
            math.cos = function(x)
                local deg = math.floor(math.deg(x) % 360)
                return precomputedTrig[deg] and precomputedTrig[deg].cos or mathopt.original_cos(x)
            end
            math.tan = function(x)
                local deg = math.floor(math.deg(x) % 360)
                return precomputedTrig[deg] and precomputedTrig[deg].tan or mathopt.original_tan(x)
            end
        end,
        disable = function()
            print("[BigMem] Disabling precomputed trigonometry")
            math.cos = mathopt.original_cos
            math.tan = mathopt.original_tan
        end,
    },
    memoization = {
        enable = function()
            print("[BigMem] Enabling memoization")
            memoize = function(func)
                local cache = {}
                return function(...)
                    local args = {...}
                    local key = table.concat(args, ",")
                    if not cache[key] then
                        cache[key] = func(...)
                    end
                    return cache[key]
                end
            end
        end,
        disable = function()
            print("[BigMem] Disabling memoization")
            memoize = function(func) return func end
        end
    },
    fastFibonacci = {
        enable = function() print("[BigMem] Enabling fibonacci") math.fibonacci = mathopt.fast_fibonacci end,
        disable = function() print("[BigMem] Disabling fibonacci") math.fibonacci = nil end,
    },
    fastBinomial = {
        enable = function() print("[BigMem] Enabling binomial") math.binomial = mathopt.fast_binomial end,
        disable = function() print("[BigMem] Disabling binomial") math.binomial = nil end,
    }
}

return mathopt
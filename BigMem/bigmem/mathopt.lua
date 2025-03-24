-- bigmem/mathopt.lua
local mathopt = {}

print("[BigMem] Applying math optimizations...")

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

-- Precompute trigonometric values
local function precomputeTrig()
    for i = 0, 360 do
        local rad = math.rad(i)
        precomputedTrig[i] = {sin = math.sin(rad), cos = math.cos(rad), tan = math.tan(rad)}
    end
    print("[BigMem] Precomputed trigonometric values")
end

-- Fast log10
mathopt.fast_log10 = function(x)
    local log = math.log(x)
    return log * 0.4342944819 -- = 1/log(10)
end

-- Fast logarithm base 10 for large numbers
mathopt.fast_log10_large = function(x)
    if type(x) ~= "number" or x <= 0 then return -math.huge end
    local log = math.log(x)
    return log * 0.4342944819 -- = 1/log(10)
end

-- Fast power approximation
mathopt.fast_pow = function(a, b)
    return math.exp(b * math.log(a))
end

-- Fast power approximation for large numbers
mathopt.fast_pow_large = function(a, b)
    if a == 0 then return 0 end
    return math.exp(b * math.log(a))
end

-- Fast exponential approximation using series expansion
mathopt.fast_exp = function(x)
    local result = 1
    local term = 1
    for i = 1, 10 do
        term = term * x / i
        result = result + term
    end
    return result
end

-- Fast exponential approximation for large numbers
mathopt.fast_exp_large = function(x)
    return (1 + x / 1024) ^ 1024
end

-- Fast square root approximation using Newton-Raphson method
mathopt.fast_sqrt = function(x)
    local guess = x / 2
    for i = 1, 5 do
        guess = (guess + x / guess) / 2
    end
    return guess
end

-- Fast cosine approximation using a polynomial
mathopt.fast_cos = function(x)
    local x2 = x * x
    return 1 - (x2 / 2) + (x2 * x2 / 24)
end

-- Fast tangent approximation using a polynomial
mathopt.fast_tan = function(x)
    local x2 = x * x
    return x + (x2 * x / 3) + (x2 * x2 * x / 5)
end

-- Fast sine approximation using a polynomial
mathopt.fast_sin = function(x)
    local x2 = x * x
    return x - (x2 * x / 6) + (x2 * x2 * x / 120)
end

-- Fast factorial approximation using Stirling's approximation
mathopt.fast_factorial = memoize(function(n)
    if n == 0 then return 1 end
    return math.sqrt(2 * math.pi * n) * (n / math.exp(1)) ^ n
end)

-- Fast gamma function approximation using Lanczos approximation
mathopt.fast_gamma = memoize(function(z)
    local g = 7
    local p = {
        0.99999999999980993,
        676.5203681218851,
        -1259.1392167224028,
        771.32342877765313,
        -176.61502916214059,
        12.507343278686905,
        -0.13857109526572012,
        9.9843695780195716e-6,
        1.5056327351493116e-7
    }
    if z < 0.5 then
        return math.pi / (math.sin(math.pi * z) * mathopt.fast_gamma(1 - z))
    else
        z = z - 1
        local x = p[1]
        for i = 2, g + 2 do
            x = x + p[i] / (z + i - 1)
        end
        local t = z + g + 0.5
        return math.sqrt(2 * math.pi) * t ^ (z + 0.5) * math.exp(-t) * x
    end
end)

-- Fast Fibonacci calculation using Binet's formula
mathopt.fast_fibonacci = memoize(function(n)
    local phi = (1 + math.sqrt(5)) / 2
    return math.floor((phi ^ n - (-phi) ^ (-n)) / math.sqrt(5) + 0.5)
end)

-- Fast binomial coefficient calculation
mathopt.fast_binomial = memoize(function(n, k)
    if k > n then return 0 end
    if k == 0 or k == n then return 1 end
    return mathopt.fast_factorial(n) / (mathopt.fast_factorial(k) * mathopt.fast_factorial(n - k))
end)

-- Tetration (a^^b) with memoization
mathopt.tetration = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = mathopt.fast_pow(a, result)
    end
    return result
end)

-- Pentation (a^^^b) with memoization
mathopt.pentation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = mathopt.tetration(a, result)
    end
    return result
end)

-- Hexation (a^^^^b) with memoization
mathopt.hexation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = mathopt.pentation(a, result)
    end
    return result
end)

-- Heptation (a^^^^^b) with memoization
mathopt.heptation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = mathopt.hexation(a, result)
    end
    return result
end)

-- Octation (a^^^^^^b) with memoization
mathopt.octation = memoize(function(a, b)
    if b == 0 then return 1 end
    local result = a
    for i = 2, b do
        result = mathopt.heptation(a, result)
    end
    return result
end)

-- Fast logarithm base 2
mathopt.fast_log2 = function(x)
    return math.log(x) / math.log(2)
end

-- Fast logarithm base 2 for large numbers
mathopt.fast_log2_large = function(x)
    if type(x) ~= "number" or x <= 0 then return -math.huge end
    return math.log(x) / math.log(2)
end

-- Fast natural logarithm
mathopt.fast_ln = function(x)
    return math.log(x)
end

-- Fast natural logarithm for large numbers
mathopt.fast_ln_large = function(x)
    if type(x) ~= "number" or x <= 0 then return -math.huge end
    return math.log(x)
end

-- Enable fast log10 function
function mathopt.enableLog10()
    print("[BigMem] Enabling fast log10")
    math.log10 = mathopt.fast_log10
end

-- Disable fast log10 function
function mathopt.disableLog10()
    print("[BigMem] Disabling fast log10")
    math.log10 = mathopt.original_log10
end

-- Enable fast exponential function using series expansion
function mathopt.enableExp()
    print("[BigMem] Enabling fast exponential")
    math.exp = mathopt.fast_exp
end

-- Disable fast exponential function
function mathopt.disableExp()
    print("[BigMem] Disabling fast exponential")
    math.exp = mathopt.original_exp
end

-- Enable fast square root function using Newton-Raphson method
function mathopt.enableSqrt()
    print("[BigMem] Enabling fast square root")
    math.sqrt = mathopt.fast_sqrt
end

-- Disable fast square root function
function mathopt.disableSqrt()
    print("[BigMem] Disabling fast square root")
    math.sqrt = mathopt.original_sqrt
end

-- Enable fast cosine function using polynomial approximation
function mathopt.enableCos()
    print("[BigMem] Enabling fast cosine")
    math.cos = mathopt.fast_cos
end

-- Disable fast cosine function
function mathopt.disableCos()
    print("[BigMem] Disabling fast cosine")
    math.cos = mathopt.original_cos
end

-- Enable fast tangent function using polynomial approximation
function mathopt.enableTan()
    print("[BigMem] Enabling fast tangent")
    math.tan = mathopt.fast_tan
end

-- Disable fast tangent function
function mathopt.disableTan()
    print("[BigMem] Disabling fast tangent")
    math.tan = mathopt.original_tan
end

-- Enable fast sine function using polynomial approximation
function mathopt.enableSin()
    print("[BigMem] Enabling fast sine")
    math.sin = mathopt.fast_sin
end

-- Disable fast sine function
function mathopt.disableSin()
    print("[BigMem] Disabling fast sine")
    math.sin = mathopt.original_sin
end

-- Enable fast power function
function mathopt.enablePow()
    print("[BigMem] Enabling fast power")
    math.pow = mathopt.fast_pow
end

-- Disable fast power function
function mathopt.disablePow()
    print("[BigMem] Disabling fast power")
    math.pow = mathopt.original_pow
end

-- Enable fast logarithm base 10 for large numbers
function mathopt.enableLog10Large()
    print("[BigMem] Enabling fast log10 for large numbers")
    math.log10 = mathopt.fast_log10_large
end

-- Disable fast logarithm base 10 for large numbers
function mathopt.disableLog10Large()
    print("[BigMem] Disabling fast log10 for large numbers")
    math.log10 = mathopt.original_log10
end

-- Enable fast power function for large numbers
function mathopt.enablePowLarge()
    print("[BigMem] Enabling fast power for large numbers")
    math.pow = mathopt.fast_pow_large
end

-- Disable fast power function for large numbers
function mathopt.disablePowLarge()
    print("[BigMem] Disabling fast power for large numbers")
    math.pow = mathopt.fast_pow
end

-- Enable fast exponential function for large numbers
function mathopt.enableExpLarge()
    print("[BigMem] Enabling fast exponential for large numbers")
    math.exp = mathopt.fast_exp_large
end

-- Disable fast exponential function for large numbers
function mathopt.disableExpLarge()
    print("[BigMem] Disabling fast exponential for large numbers")
    math.exp = mathopt.original_exp
end

-- Enable fast factorial function
function mathopt.enableFactorial()
    print("[BigMem] Enabling fast factorial")
    math.factorial = mathopt.fast_factorial
end

-- Disable fast factorial function
function mathopt.disableFactorial()
    print("[BigMem] Disabling fast factorial")
    math.factorial = nil
end

-- Enable fast gamma function
function mathopt.enableGamma()
    print("[BigMem] Enabling fast gamma")
    math.gamma = mathopt.fast_gamma
end

-- Disable fast gamma function
function mathopt.disableGamma()
    print("[BigMem] Disabling fast gamma")
    math.gamma = nil
end

-- Enable fast Fibonacci function
function mathopt.enableFibonacci()
    print("[BigMem] Enabling fast Fibonacci")
    math.fibonacci = mathopt.fast_fibonacci
end

-- Disable fast Fibonacci function
function mathopt.disableFibonacci()
    print("[BigMem] Disabling fast Fibonacci")
    math.fibonacci = nil
end

-- Enable fast binomial coefficient function
function mathopt.enableBinomial()
    print("[BigMem] Enabling fast binomial coefficient")
    math.binomial = mathopt.fast_binomial
end

-- Disable fast binomial coefficient function
function mathopt.disableBinomial()
    print("[BigMem] Disabling fast binomial coefficient")
    math.binomial = nil
end

-- Enable fast logarithm base 2 function
function mathopt.enableLog2()
    print("[BigMem] Enabling fast log2")
    math.log2 = mathopt.fast_log2
end

-- Disable fast logarithm base 2 function
function mathopt.disableLog2()
    print("[BigMem] Disabling fast log2")
    math.log2 = nil
end

-- Enable fast logarithm base 2 for large numbers
function mathopt.enableLog2Large()
    print("[BigMem] Enabling fast log2 for large numbers")
    math.log2 = mathopt.fast_log2_large
end

-- Disable fast logarithm base 2 for large numbers
function mathopt.disableLog2Large()
    print("[BigMem] Disabling fast log2 for large numbers")
    math.log2 = nil
end

-- Enable fast natural logarithm function
function mathopt.enableLn()
    print("[BigMem] Enabling fast ln")
    math.ln = mathopt.fast_ln
end

-- Disable fast natural logarithm function
function mathopt.disableLn()
    print("[BigMem] Disabling fast ln")
    math.ln = nil
end

-- Enable fast natural logarithm for large numbers
function mathopt.enableLnLarge()
    print("[BigMem] Enabling fast ln for large numbers")
    math.ln = mathopt.fast_ln_large
end

-- Disable fast natural logarithm for large numbers
function mathopt.disableLnLarge()
    print("[BigMem] Disabling fast ln for large numbers")
    math.ln = nil
end

-- Enable memoization
function mathopt.enableMemoization()
    print("[BigMem] Enabling memoization")
    math.cos = memoize(math.cos)
    math.tan = memoize(math.tan)
end

-- Disable memoization
function mathopt.disableMemoization()
    print("[BigMem] Disabling memoization")
    math.cos = mathopt.original_cos
    math.tan = mathopt.original_tan
end

-- Enable precomputed trigonometry
function mathopt.enablePrecomputedTrig()
    print("[BigMem] Enabling precomputed trigonometry")
    precomputeTrig()
    math.cos = function(x)
        local deg = math.floor(math.deg(x) % 360)
        if precomputedTrig[deg] then
            return precomputedTrig[deg].cos
        else
            print("[BigMem] Error: precomputedTrig[" .. deg .. "] is nil")
            return mathopt.original_cos(x)
        end
    end
    math.tan = function(x)
        local deg = math.floor(math.deg(x) % 360)
        if precomputedTrig[deg] then
            return precomputedTrig[deg].tan
        else
            print("[BigMem] Error: precomputedTrig[" .. deg .. "] is nil")
            return mathopt.original_tan(x)
        end
    end
end

-- Disable precomputed trigonometry
function mathopt.disablePrecomputedTrig()
    print("[BigMem] Disabling precomputed trigonometry")
    math.cos = mathopt.original_cos
    math.tan = mathopt.original_tan
end

-- Enable tetration
function mathopt.enableTetration()
    print("[BigMem] Enabling tetration")
    math.tetration = mathopt.tetration
end

-- Disable tetration
function mathopt.disableTetration()
    print("[BigMem] Disabling tetration")
    math.tetration = nil
end

-- Enable pentation
function mathopt.enablePentation()
    print("[BigMem] Enabling pentation")
    math.pentation = mathopt.pentation
end

-- Disable pentation
function mathopt.disablePentation()
    print("[BigMem] Disabling pentation")
    math.pentation = nil
end

-- Enable hexation
function mathopt.enableHexation()
    print("[BigMem] Enabling hexation")
    math.hexation = mathopt.hexation
end

-- Disable hexation
function mathopt.disableHexation()
    print("[BigMem] Disabling hexation")
    math.hexation = nil
end

-- Enable heptation
function mathopt.enableHeptation()
    print("[BigMem] Enabling heptation")
    math.heptation = mathopt.heptation
end

-- Disable heptation
function mathopt.disableHeptation()
    print("[BigMem] Disabling heptation")
    math.heptation = nil
end

-- Enable octation
function mathopt.enableOctation()
    print("[BigMem] Enabling octation")
    math.octation = mathopt.octation
end

-- Disable octation
function mathopt.disableOctation()
    print("[BigMem] Disabling octation")
    math.octation = nil
end

-- Add a calculation to the batch queue
function mathopt.addToBatch(func, ...)
    table.insert(batchQueue, {func = func, args = {...}})
end

-- Execute all calculations in the batch queue
function mathopt.executeBatch()
    for _, item in ipairs(batchQueue) do
        item.func(table.unpack(item.args))
    end
    batchQueue = {}
end

-- Enable batching
function mathopt.enableBatching()
    print("[BigMem] Enabling batching")
    batchingEnabled = true
end

-- Disable batching
function mathopt.disableBatching()
    print("[BigMem] Disabling batching")
    batchingEnabled = false
    mathopt.executeBatch()
end

-- Add a calculation to the batch queue with a delay
function mathopt.addToBatchWithDelay(func, delay, ...)
    table.insert(batchQueue, {func = func, delay = delay, args = {...}})
end

-- Execute all calculations in the batch queue with delays
function mathopt.executeBatchWithDelay()
    local currentTime = love.timer.getTime()
    for _, item in ipairs(batchQueue) do
        if currentTime >= item.delay then
            item.func(table.unpack(item.args))
        end
    end
    batchQueue = {}
end

-- Add a calculation to the batch queue with a priority
function mathopt.addToBatchWithPriority(func, priority, ...)
    table.insert(batchQueue, {func = func, priority = priority, args = {...}})
    table.sort(batchQueue, function(a, b) return a.priority < b.priority end)
end

-- Execute all calculations in the batch queue with priorities
function mathopt.executeBatchWithPriority()
    for _, item in ipairs(batchQueue) do
        item.func(table.unpack(item.args))
    end
    batchQueue = {}
end

-- Enable priority-based batching
function mathopt.enablePriorityBatching()
    print("[BigMem] Enabling priority-based batching")
    batchingEnabled = true
end

-- Disable priority-based batching
function mathopt.disablePriorityBatching()
    print("[BigMem] Disabling priority-based batching")
    batchingEnabled = false
    mathopt.executeBatchWithPriority()
end

return mathopt
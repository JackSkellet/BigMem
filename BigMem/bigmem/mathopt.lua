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

-- Fast power approximation
mathopt.fast_pow = function(a, b)
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
    return 1 - x2 / 2 + x2 * x2 / 24
end

-- Fast tangent approximation using a polynomial
mathopt.fast_tan = function(x)
    local x2 = x * x
    return x + x2 * x / 3 + x2 * x2 * x / 5
end

-- Fast sine approximation using a polynomial
mathopt.fast_sin = function(x)
    local x2 = x * x
    return x - x2 * x / 6 + x2 * x2 * x / 120
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

-- Fast natural logarithm
mathopt.fast_ln = function(x)
    return math.log(x)
end

-- Enable/Disable functions
local function enableFastMathFunction(name, fastFunc)
    print("[BigMem] Enabling fast " .. name)
    math[name] = fastFunc
end

local function disableFastMathFunction(name, originalFunc)
    print("[BigMem] Disabling fast " .. name)
    math[name] = originalFunc
end

function mathopt.enableLog10() enableFastMathFunction("log10", mathopt.fast_log10) end
function mathopt.disableLog10() disableFastMathFunction("log10", mathopt.original_log10) end
function mathopt.enableExp() enableFastMathFunction("exp", mathopt.fast_exp) end
function mathopt.disableExp() disableFastMathFunction("exp", mathopt.original_exp) end
function mathopt.enableSqrt() enableFastMathFunction("sqrt", mathopt.fast_sqrt) end
function mathopt.disableSqrt() disableFastMathFunction("sqrt", mathopt.original_sqrt) end
function mathopt.enableCos() enableFastMathFunction("cos", mathopt.fast_cos) end
function mathopt.disableCos() disableFastMathFunction("cos", mathopt.original_cos) end
function mathopt.enableTan() enableFastMathFunction("tan", mathopt.fast_tan) end
function mathopt.disableTan() disableFastMathFunction("tan", mathopt.original_tan) end
function mathopt.enablePow() enableFastMathFunction("pow", mathopt.fast_pow) end
function mathopt.disablePow() disableFastMathFunction("pow", mathopt.original_pow) end
function mathopt.enableFactorial() enableFastMathFunction("factorial", mathopt.fast_factorial) end
function mathopt.disableFactorial() disableFastMathFunction("factorial", nil) end
function mathopt.enableGamma() enableFastMathFunction("gamma", mathopt.fast_gamma) end
function mathopt.disableGamma() disableFastMathFunction("gamma", nil) end
function mathopt.enableFibonacci() enableFastMathFunction("fibonacci", mathopt.fast_fibonacci) end
function mathopt.disableFibonacci() disableFastMathFunction("fibonacci", nil) end
function mathopt.enableBinomial() enableFastMathFunction("binomial", mathopt.fast_binomial) end
function mathopt.disableBinomial() disableFastMathFunction("binomial", nil) end
function mathopt.enableLog2() enableFastMathFunction("log2", mathopt.fast_log2) end
function mathopt.disableLog2() disableFastMathFunction("log2", nil) end
function mathopt.enableLn() enableFastMathFunction("ln", mathopt.fast_ln) end
function mathopt.disableLn() disableFastMathFunction("ln", nil) end
function mathopt.enableSin() enableFastMathFunction("sin", mathopt.fast_sin) end
function mathopt.disableSin() disableFastMathFunction("sin", mathopt.original_sin) end

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

-- Enable/Disable memoization
function mathopt.enableMemoization()
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
end

function mathopt.disableMemoization()
    print("[BigMem] Disabling memoization")
    memoize = function(func)
        return func
    end
end


-- Add a calculation to the batch queue with priority, dependencies, and timeout
function mathopt.addToBatch(func, priority, dependencies, timeout, ...)
    table.insert(batchQueue, {
        func = func,
        priority = priority or 0,
        dependencies = dependencies or {},
        timeout = timeout or 0,
        args = {...}
    })
end

-- Execute all calculations in the batch queue
function mathopt.executeBatch()
    -- Sort the batch queue by priority
    table.sort(batchQueue, function(a, b)
        return a.priority > b.priority
    end)

    local currentTime = love.timer.getTime()
    local executed = {}

    for _, item in ipairs(batchQueue) do
        -- Check if all dependencies are met
        local dependenciesMet = true
        for _, dep in ipairs(item.dependencies) do
            if not executed[dep] then
                dependenciesMet = false
                break
            end
        end

        -- Check if the timeout has been reached
        if dependenciesMet and (item.timeout == 0 or currentTime >= item.timeout) then
            local success, err = pcall(item.func, table.unpack(item.args))
            if success then
                executed[item.func] = true
            else
                print("[BigMem] Error executing batch item:", err)
            end
        end
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

return mathopt
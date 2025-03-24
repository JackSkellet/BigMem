local BigMemConfig = {}
local configMemory = {}

local configDefinition = {
    enableLogging = {
        label = "Enable Memory Logging",
        type = "toggle",
        default = false,
        info = { "Prints memory usage info to the console." }
    },
    optimizeInterval = {
        label = "GC Interval (Seconds)",
        type = "select",
        default = 30,
        values = { 5, 15, 25, 45, 60 },
        info = { "How often to run garbage collection." }
    },
    superBoostMode = {
        label = "Visual Functions Toggle",
        type = "toggle",
        default = true,
        info = { "Applies various performance optimizations." }
    },
    fastPow = {
        label = "Enable Fast Power Function",
        type = "toggle",
        default = true,
        info = { "Uses optimized power function for better performance." }
    },
    fastLog10 = {
        label = "Enable Fast Log10 Function",
        type = "toggle",
        default = true,
        info = { "Uses optimized log10 function for better performance." }
    },
    fastExp = {
        label = "Enable Fast Exponential Function",
        type = "toggle",
        default = true,
        info = { "Uses optimized exponential function for better performance." }
    },
    fastSqrt = {
        label = "Enable Fast Square Root Function",
        type = "toggle",
        default = true,
        info = { "Uses optimized square root function for better performance." }
    },
    memoization = {
        label = "Enable Memoization",
        type = "toggle",
        default = true,
        info = { "Caches results of expensive math calculations." }
    },
    precomputedTrig = {
        label = "Use Precomputed Trigonometry",
        type = "toggle",
        default = false,
        info = { "Speeds up trig calculations with lookup tables." }
    },
    reduceAnimations = {
        label = "Simplify Animations",
        type = "toggle",
        default = true,
        info = { "Disables certain visual animations to increase performance." }
    },
    fastLog10Large = {
        label = "Enable Fast Log10 for Large Numbers",
        type = "toggle",
        default = false,
        info = { "Uses optimized log10 function for large numbers." }
    },
    fastPowLarge = {
        label = "Enable Fast Power for Large Numbers",
        type = "toggle",
        default = false,
        info = { "Uses optimized power function for large numbers." }
    },
    fastExpLarge = {
        label = "Enable Fast Exponential for Large Numbers",
        type = "toggle",
        default = false,
        info = { "Uses optimized exponential function for large numbers." }
    },
    limitFramerate = {
        label = "Limit Framerate",
        type = "select",
        default = 60,
        values = { 60, 144, 240, "Unlimited" },
        info = { "Limits the maximum framerate to reduce CPU/GPU usage." }
    },
    disableParticles = {
        label = "Disable Particles",
        type = "toggle",
        default = false,
        info = { "Disables particle effects to improve performance." }
    },
    drawNonEssentialShaders = {
        label = "Draw Non-Essential Shaders",
        type = "toggle",
        default = true,
        info = { "Draws non-essential shaders for visual effects." }
    },
    hideConsumables = {
        label = "Hide Consumables",
        type = "toggle",
        default = false,
        info = { "Hides consumable items to improve performance." }
    },
    hideDeck = {
        label = "Hide Deck",
        type = "toggle",
        default = false,
        info = { "Hides the deck to improve performance." }
    },
    tetration = {
        label = "Enable Tetration",
        type = "toggle",
        default = false,
        info = { "Enables tetration (a^^b) calculations." }
    },
    pentation = {
        label = "Enable Pentation",
        type = "toggle",
        default = false,
        info = { "Enables pentation (a^^^b) calculations." }
    },
    hexation = {
        label = "Enable Hexation",
        type = "toggle",
        default = false,
        info = { "Enables hexation (a^^^^b) calculations." }
    },
    heptation = {
        label = "Enable Heptation",
        type = "toggle",
        default = false,
        info = { "Enables heptation (a^^^^^b) calculations." }
    },
    octation = {
        label = "Enable Octation",
        type = "toggle",
        default = false,
        info = { "Enables octation (a^^^^^^b) calculations." }
    },
    enableBatching = {
        label = "Enable Batching",
        type = "toggle",
        default = false,
        info = { "Enables batching of calculations to improve performance." }
    },
    fastFibonacci = {
        label = "Enable Fast Fibonacci Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized Fibonacci function for better performance." }
    },
    fastBinomial = {
        label = "Enable Fast Binomial Coefficient Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized binomial coefficient function for better performance." }
    },
    fastLog2 = {
        label = "Enable Fast Log2 Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized log2 function for better performance." }
    },
    fastLog2Large = {
        label = "Enable Fast Log2 for Large Numbers",
        type = "toggle",
        default = false,
        info = { "Uses optimized log2 function for large numbers." }
    },
    fastLn = {
        label = "Enable Fast Natural Logarithm Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized natural logarithm function for better performance." }
    },
    fastLnLarge = {
        label = "Enable Fast Natural Logarithm for Large Numbers",
        type = "toggle",
        default = false,
        info = { "Uses optimized natural logarithm function for large numbers." }
    },
    fastInvSqrt = {
        label = "Enable Fast Inverse Square Root Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized inverse square root function for better performance." }
    },
    fastReciprocal = {
        label = "Enable Fast Reciprocal Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized reciprocal function for better performance." }
    },
    fastReciprocalSqrt = {
        label = "Enable Fast Reciprocal Square Root Function",
        type = "toggle",
        default = false,
        info = { "Uses optimized reciprocal square root function for better performance." }
    },
    fastSqrtNewton = {
        label = "Enable Fast Square Root (Newton-Raphson)",
        type = "toggle",
        default = false,
        info = { "Uses Newton-Raphson method for fast square root approximation." }
    },
    fastExpSeries = {
        label = "Enable Fast Exponential (Series Expansion)",
        type = "toggle",
        default = false,
        info = { "Uses series expansion for fast exponential approximation." }
    },
    fastSinPoly = {
        label = "Enable Fast Sine (Polynomial)",
        type = "toggle",
        default = false,
        info = { "Uses polynomial approximation for fast sine calculation." }
    },
    fastCosPoly = {
        label = "Enable Fast Cosine (Polynomial)",
        type = "toggle",
        default = false,
        info = { "Uses polynomial approximation for fast cosine calculation." }
    },
    fastTanPoly = {
        label = "Enable Fast Tangent (Polynomial)",
        type = "toggle",
        default = false,
        info = { "Uses polynomial approximation for fast tangent calculation." }
    },
    rainbowTint = {
        label = "BRB Message",
        type = "toggle",
        default = false,
        info = { "Displays a BRB message on the screen." }
    },
}

local function hasValue(tab, val)
    for i, v in ipairs(tab) do
        if v == val then return i end
    end
    return false
end

function BigMemConfig.loadConfig()
    if not love.filesystem.getInfo("config/BigMem.cfg") then return end
    local data = love.filesystem.read("config/BigMem.cfg")
    for line in data:gmatch("[^\r\n]+") do
        local key, value = line:match("([^=]+)=([^=]+)")
        if key and configDefinition[key] then
            local def = configDefinition[key]
            if def.type == "toggle" then
                value = (value == "true")
            elseif def.type == "select" then
                if value == "Unlimited" then
                    value = "Unlimited"
                else
                    value = tonumber(value)
                end
            else
                value = tonumber(value)
            end
            configMemory[key] = { value = value }
        end
    end
    BigMemConfig.applySettings()
end

function BigMemConfig.saveConfig()
    local saveData = {}
    for k, v in pairs(configMemory) do
        table.insert(saveData, k .. "=" .. tostring(v.value))
    end
    love.filesystem.createDirectory("config")
    love.filesystem.write("config/BigMem.cfg", table.concat(saveData, "\n"))
end

function BigMemConfig.setValue(key, value)
    configMemory[key] = { value = value }
    BigMemConfig.applySetting(key, value)
    BigMemConfig.saveConfig()
end

function BigMemConfig.applySetting(key, value)
    local mathopt = require("bigmem.mathopt")
    if key == "fastPow" then
        if value then
            mathopt.enablePow()
        else
            mathopt.disablePow()
        end
    elseif key == "fastLog10" then
        if value then
            mathopt.enableLog10()
        else
            mathopt.disableLog10()
        end
    elseif key == "fastExp" then
        if value then
            mathopt.enableExp()
        else
            mathopt.disableExp()
        end
    elseif key == "fastSqrt" then
        if value then
            mathopt.enableSqrt()
        else
            mathopt.disableSqrt()
        end
    elseif key == "fastLog10Large" then
        if value then
            mathopt.enableLog10Large()
        else
            mathopt.disableLog10Large()
        end
    elseif key == "fastPowLarge" then
        if value then
            mathopt.enablePowLarge()
        else
            mathopt.disablePowLarge()
        end
    elseif key == "fastExpLarge" then
        if value then
            mathopt.enableExpLarge()
        else
            mathopt.disableExpLarge()
        end
    elseif key == "memoization" then
        if value then
            mathopt.enableMemoization()
        else
            mathopt.disableMemoization()
        end
    elseif key == "precomputedTrig" then
        if value then
            mathopt.enablePrecomputedTrig()
        else
            mathopt.disablePrecomputedTrig()
        end
    elseif key == "limitFramerate" then
        if value == "Unlimited" then
            love.window.setMode(0, 0, {vsync = false})
        elseif value then
            love.window.setMode(0, 0, {vsync = false})
            love.timer.sleep(1 / value)
        end
        print("[BigMem] Framerate Limit set to: " .. tostring(value))
    elseif key == "optimizeInterval" then
        print("[BigMem] GC Interval set to: " .. tostring(value))
    elseif key == "disableParticles" then
        if value then
            love.graphics.setDefaultFilter("nearest", "nearest")
        else
            love.graphics.setDefaultFilter("linear", "linear")
        end
    elseif key == "drawNonEssentialShaders" then
        -- No specific function to call, handled in superboost.lua
    elseif key == "hideConsumables" then
        -- No specific function to call, handled in superboost.lua
    elseif key == "hideDeck" then
        -- No specific function to call, handled in superboost.lua
    elseif key == "tetration" then
        if value then
            mathopt.enableTetration()
        else
            mathopt.disableTetration()
        end
    elseif key == "pentation" then
        if value then
            mathopt.enablePentation()
        else
            mathopt.disablePentation()
        end
    elseif key == "hexation" then
        if value then
            mathopt.enableHexation()
        else
            mathopt.disableHexation()
        end
    elseif key == "heptation" then
        if value then
            mathopt.enableHeptation()
        else
            mathopt.disableHeptation()
        end
    elseif key == "octation" then
        if value then
            mathopt.enableOctation()
        else
            mathopt.disableOctation()
        end
    elseif key == "enableBatching" then
        if value then
            mathopt.enableBatching()
        else
            mathopt.disableBatching()
        end
    elseif key == "drunkMode" then
        require("bigmem.drunkmode").apply(value)
    elseif key == "fastFibonacci" then
        if value then
            mathopt.enableFibonacci()
        else
            mathopt.disableFibonacci()
        end
    elseif key == "fastBinomial" then
        if value then
            mathopt.enableBinomial()
        else
            mathopt.disableBinomial()
        end
    elseif key == "fastLog2" then
        if value then
            mathopt.enableLog2()
        else
            mathopt.disableLog2()
        end
    elseif key == "fastLog2Large" then
        if value then
            mathopt.enableLog2Large()
        else
            mathopt.disableLog2Large()
        end
    elseif key == "fastLn" then
        if value then
            mathopt.enableLn()
        else
            mathopt.disableLn()
        end
    elseif key == "fastLnLarge" then
        if value then
            mathopt.enableLnLarge()
        else
            mathopt.disableLnLarge()
        end
    elseif key == "fastInvSqrt" then
        if value then
            mathopt.enableInvSqrt()
        else
            mathopt.disableInvSqrt()
        end
    elseif key == "fastReciprocal" then
        if value then
            mathopt.enableReciprocal()
        else
            mathopt.disableReciprocal()
        end
    elseif key == "fastReciprocalSqrt" then
        if value then
            mathopt.enableReciprocalSqrt()
        else
            mathopt.disableReciprocalSqrt()
        end
    elseif key == "fastSqrtNewton" then
        if value then
            mathopt.disableSqrt() -- Disable other sqrt optimizations
            mathopt.enableSqrt()
        else
            mathopt.disableSqrt()
        end
    elseif key == "fastExpSeries" then
        if value then
            mathopt.disableExp() -- Disable other exp optimizations
            mathopt.enableExp()
        else
            mathopt.disableExp()
        end
    elseif key == "fastSinPoly" then
        if value then
            mathopt.disableSin() -- Disable other sin optimizations
            mathopt.enableSin()
        else
            mathopt.disableSin()
        end
    elseif key == "fastCosPoly" then
        if value then
            mathopt.disableCos() -- Disable other cos optimizations
            mathopt.enableCos()
        else
            mathopt.disableCos()
        end
    elseif key == "fastTanPoly" then
        if value then
            mathopt.disableTan() -- Disable other tan optimizations
            mathopt.enableTan()
        else
            mathopt.disableTan()
        end
    elseif key == "reduceAnimations" then
        if value then
            G.SHADERS_ENABLED = false
        else
            G.SHADERS_ENABLED = true
        end
    elseif key == "superBoostMode" then
        require("bigmem.superboost").apply(value)
    elseif key == "rainbowTint" then
        require("bigmem.superboost").apply(BigMemConfig.getValue("superBoostMode"))
    end
end

function BigMemConfig.applySettings()
    for key, setting in pairs(configMemory) do
        BigMemConfig.applySetting(key, setting.value)
    end
end

function BigMemConfig.getValue(key)
    return configMemory[key] and configMemory[key].value or configDefinition[key].default
end

function BigMemConfig.generateConfigTabs()
    return {
        {
            label = "Performance",
            tab_definition_function = function(args)
                local nodes = {}
                for key, def in pairs(configDefinition) do
                    if hasValue({ 
                        "enableLogging", 
                        "optimizeInterval", 
                        "limitFramerate"
                    }, key) then
                        local ref = configMemory[key] or { value = def.default }

                        if def.type == "toggle" then
                            table.insert(nodes, create_toggle({
                                label = def.label,
                                ref_table = ref,
                                ref_value = "value",
                                callback = function(v)
                                    BigMemConfig.setValue(key, v)
                                end,
                                info = def.info,
                                config = { font_size = 5 } -- Smaller font size
                            }))
                        elseif def.type == "select" then
                            local idx = hasValue(def.values, BigMemConfig.getValue(key)) or 1
                            table.insert(nodes, create_option_cycle({
                                options = def.values,
                                current_option = idx,
                                opt_callback = "BigMem_conf_select_callback",
                                label = def.label,
                                dp_key = key,
                                info = def.info,
                                config = { font_size = 10 } -- Smaller font size
                            }))
                        end
                    end
                end

                return {
                    n = G.UIT.ROOT,
                    config = { r = 0.1, minw = 7, minh = 5, align = "cm", padding = 0.3, colour = G.C.BLACK },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm", padding = 0.1 },
                            nodes = nodes
                        }
                    }
                }
            end,
            tab_definition_function_args = { index = 1 }
        },
        {
            label = "Visuals",
            tab_definition_function = function(args)
                local nodes = {}
                for _, key in ipairs({"superBoostMode", "reduceAnimations", "hideConsumables", "hideDeck"}) do
                    local def = configDefinition[key]
                    local ref = configMemory[key] or { value = def.default }

                    if def then
                        if def.type == "toggle" then
                            table.insert(nodes, create_toggle({
                                label = def.label,
                                ref_table = ref,
                                ref_value = "value",
                                callback = function(v)
                                    BigMemConfig.setValue(key, v)
                                end,
                                info = def.info,
                                config = { font_size = 5 } -- Smaller font size
                            }))
                        elseif def.type == "select" then
                            local idx = hasValue(def.values, BigMemConfig.getValue(key)) or 1
                            table.insert(nodes, create_option_cycle({
                                options = def.values,
                                current_option = idx,
                                opt_callback = "BigMem_conf_select_callback",
                                label = def.label,
                                dp_key = key,
                                info = def.info,
                                config = { font_size = 10 } -- Smaller font size
                            }))
                        end
                    end
                end

                return {
                    n = G.UIT.ROOT,
                    config = { r = 0.1, minw = 7, minh = 5, align = "cm", padding = 0.5, colour = G.C.BLACK },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm", padding = 0.1 },
                            nodes = nodes
                        }
                    }
                }
            end,
            tab_definition_function_args = { index = 2 }
        },
        {
            label = "Normal Math",
            tab_definition_function = function(args)
                local nodes = {}
                for key, def in pairs(configDefinition) do
                    if hasValue({ "fastPow", "fastLog10", "fastExp", "fastSqrt", "fastLog2", "fastLog2Large", "fastLn", "fastLnLarge" }, key) then
                        local ref = configMemory[key] or { value = def.default }
                        if def.type == "toggle" then
                            table.insert(nodes, create_toggle({
                                label = def.label,
                                ref_table = ref,
                                ref_value = "value",
                                callback = function(v)
                                    BigMemConfig.setValue(key, v)
                                end,
                                info = def.info,
                                config = { font_size = 5 } -- Smaller font size
                            }))
                        end
                    end
                end
                return {
                    n = G.UIT.ROOT,
                    config = { r = 0.1, minw = 7, minh = 5, align = "cm", padding = 0.3, colour = G.C.BLACK },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm", padding = 0.1 },
                            nodes = nodes
                        }
                    }
                }
            end,
            tab_definition_function_args = { index = 3 }
        },
        {
            label = "Crazy Math",
            tab_definition_function = function(args)
                local nodes = {}
                for key, def in pairs(configDefinition) do
                    if hasValue({ "tetration", "pentation", "hexation", "heptation", "octation" }, key) then
                        local ref = configMemory[key] or { value = def.default }
                        if def.type == "toggle" then
                            table.insert(nodes, create_toggle({
                                label = def.label,
                                ref_table = ref,
                                ref_value = "value",
                                callback = function(v)
                                    BigMemConfig.setValue(key, v)
                                end,
                                info = def.info,
                                config = { font_size = 5 } -- Smaller font size
                            }))
                        end
                    end
                end
                return {
                    n = G.UIT.ROOT,
                    config = { r = 0.1, minw = 7, minh = 5, align = "cm", padding = 0.3, colour = G.C.BLACK },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm", padding = 0.1 },
                            nodes = nodes
                        }
                    }
                }
            end,
            tab_definition_function_args = { index = 4 }
        },
        {
            label = "Advanced",
            tab_definition_function = function(args)
                local nodes = {}
                for key, def in pairs(configDefinition) do
                    if hasValue({ "memoization", "precomputedTrig", "enableBatching", "fastFibonacci", "fastBinomial" }, key) then
                        local ref = configMemory[key] or { value = def.default }
                        if def.type == "toggle" then
                            table.insert(nodes, create_toggle({
                                label = def.label,
                                ref_table = ref,
                                ref_value = "value",
                                callback = function(v)
                                    BigMemConfig.setValue(key, v)
                                end,
                                info = def.info,
                                config = { font_size = 5 } -- Smaller font size
                            }))
                        end
                    end
                end
                return {
                    n = G.UIT.ROOT,
                    config = { r = 0.1, minw = 7, minh = 5, align = "cm", padding = 0.3, colour = G.C.BLACK },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm", padding = 0.1 },
                            nodes = nodes
                        }
                    }
                }
            end,
            tab_definition_function_args = { index = 5 }
        }
    }
end

function G.FUNCS.BigMem_conf_select_callback(e)
    BigMemConfig.setValue(e.cycle_config.dp_key, e.to_val)
end

return BigMemConfig

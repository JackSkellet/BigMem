local M = {}

local original = G.FUNCS.evaluate_jokers or function(jokers, cards) end

function M.apply()
    print("[BigMem] Flatten Joker→Card Loop ENABLED, using optimized batching.")
    G.FUNCS.evaluate_jokers = function(jokers, cards)
        print("[BigMem] Flatten Joker→Card Loop ENABLED")
        for _, joker in ipairs(jokers) do
            if type(joker.evaluate) == "function" then
                joker:evaluate(cards)
            end
        end
    end
end

function M.disable()
    print("[BigMem] Flatten Joker→Card Loop DISABLED, restored original evaluation.")
    G.FUNCS.evaluate_jokers = original
end

return M

local M = {}

local original = G.FUNCS.evaluate_jokers or function(jokers, cards) end

function M.apply()
    print("[BigMem] Batch Joker Effects ENABLED, using optimized batching.")

    G.FUNCS.evaluate_jokers = function(jokers, cards)
        print("[BigMem] Batch Joker Effects ENABLED")

        local chip_bonus = 0
        local mult_bonus = 0

        for _, joker in ipairs(jokers) do
            if joker.effect == "add_chips" then
                chip_bonus = chip_bonus + (joker.config.amount or 0)
            elseif joker.effect == "add_mult" then
                mult_bonus = mult_bonus + (joker.config.amount or 0)
            end
        end

        G.GAME.chips = G.GAME.chips + chip_bonus
        G.GAME.mult = G.GAME.mult + mult_bonus
    end
end

function M.disable()
    print("[BigMem] Batch Joker Effects DISABLED, restored original evaluation.")
    G.FUNCS.evaluate_jokers = original
end

return M

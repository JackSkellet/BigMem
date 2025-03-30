local OmegaNum = require("bigmem.omeganum")
local omegaMeter = {}

local last_display = ""
local insanity_threshold = 1e308 -- 10^308 == start of Omega fun

function omegaMeter.draw()
    if not BigMem or not BigMem.config.smartScoreFormat then return end
    if not G or not G.GAME then return end

    local chips = G.GAME.chips or 0
    if type(chips) ~= "number" or chips < 1e6 then return end

    local num = OmegaNum:new(chips)
    local label = num:toString()

    -- Show hyperoperation tier based on magnitude
    local tier = ""
    if num.magnitude >= 1e4 then
        tier = "OMEGA {8+}"
    elseif num.magnitude >= 1e3 then
        tier = "Octation"
    elseif num.magnitude >= 1e2 then
        tier = "Hexation"
    elseif num.magnitude >= 308 then
        tier = "Tetration"
    end

    local insanity = num.magnitude >= math.log10(insanity_threshold)

    -- Background box
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", G.ROOM.width - 240, 20, 220, 60, 8, 8)

    -- Chip string
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(G.FONTS.BIG)
    love.graphics.print("Chips: " .. label, G.ROOM.width - 230, 25)

    -- Tier string
    if tier ~= "" then
        if insanity then
            love.graphics.setColor(1, 0.4, 0.2, 1) -- Fiery
        else
            love.graphics.setColor(0.6, 1.0, 0.6, 1)
        end
        love.graphics.setFont(G.FONTS.SMALL)
        love.graphics.print(tier, G.ROOM.width - 230, 50)
    end
end

return omegaMeter

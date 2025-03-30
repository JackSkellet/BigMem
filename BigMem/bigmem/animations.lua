local M = {}
local config = require("bigmem.config")

function M.apply()
    print("[BigMem] Skipping Animations ENABLED")
    -- Instantly flip and move cards
    G.FUNCS.card_flip = function(c) c.flipped = true end
    G.FUNCS.card_slide = function(c, x, y) c.x, c.y = x, y end

    -- Skip pulse effect
    G.FUNCS.pulse = function(c) end

    if config.getValue("disableParticles") then
        print("[BigMem] Disabling Particles ENABLED")
        G.FUNCS.spawn_particles = function(...) end
    end
end

function M.disable()
    print("[BigMem] Skipping Animations DISABLED")
    -- Restore original functions (if needed, store them beforehand)
    G.FUNCS.card_flip = nil
    G.FUNCS.card_slide = nil
    G.FUNCS.pulse = nil
    G.FUNCS.spawn_particles = nil
end

return M
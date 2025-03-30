local config = require("bigmem.config")
local mathopt = require("bigmem.mathopt")

local core = {
    config = config,
    OmegaNum = nil,
    initialized = false
}

BigMem = core

function core.init()
    if core.initialized then return end
    core.initialized = true

    -- Load math optimization systems
    if config.precomputeTrig or config.memoizeFactorials then
        mathopt.init()
    end

    -- Load OmegaNum support
    if config.useOmegaNum or config.smartScoreFormat then
        core.OmegaNum = require("bigmem.omeganum")
    end

    -- Apply runtime settings
    core.applySettings()

    -- Lovely UI integration
    if G.LOVELY then
        local ui_def = require("bigmem.bigmem_ui")
        G.LOVELY:register_mod("bigmem", ui_def.init())
    end

    -- Inject draw function
    if G and G.draw then
        local omegaMeter = require("bigmem.omegameter")
        local old_draw = G.draw
        G.draw = function(self, ...)
            old_draw(self, ...)
            omegaMeter.draw()
        end
    end
end

function core.applySettings()
    if config.smartScoreFormat then
        require("bigmem.scoreformat")()
    end
    if config.batchJokerEffects then
        require("bigmem.jokerlogic")()
    end
    if config.combineEvents then
        require("bigmem.events")()
    end
    if config.skipAnimations or config.disableParticles then
        require("bigmem.animations")()
    end
    if config.disableSaving then
        require("bigmem.safemode")()
    end
end

return core
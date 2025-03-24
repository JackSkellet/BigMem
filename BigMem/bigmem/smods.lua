if SMODS.current_mod then
    SMODS.current_mod.prefix = "bigmem"

    local core = require("bigmem.core")
    core.log("Initializing...")

    local config = require("bigmem.config")
    config.loadConfig()

    SMODS.current_mod.config_tab = true
    SMODS.current_mod.extra_tabs = function()
        return config.generateConfigTabs()
    end

    require("bigmem.watcher").start(config)

    -- Load the font file
    local fontPath = "assets/balatro.ttf"
    if love.filesystem.getInfo(fontPath) then
        local largeFont = love.graphics.newFont(fontPath, 400)
        require("bigmem.superboost").setLargeFont(largeFont)
    else
        core.log("Font file not found: " .. fontPath)
    end
end
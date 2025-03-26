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
end
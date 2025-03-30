if SMODS.current_mod then
    local mod = SMODS.current_mod
    mod.prefix = "bigmem"

    local core = require("bigmem.core")
    local config = require("bigmem.config")
    config.loadConfig()

    mod.config_tab = true
    mod.extra_tabs = function()
        return config.generateConfigTabs()
    end

    -- Optional: re-apply config settings if needed
    if core.applySettings then
        core.applySettings()
    end

    -- Start performance/memory watcher
    local watcher = require("bigmem.watcher")
    if watcher.start then
        watcher.start(config)
    end
end

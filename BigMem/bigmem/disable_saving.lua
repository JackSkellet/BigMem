local M = {}

local original_save_progress = G.SAVE_MANAGER and G.SAVE_MANAGER.save_progress

function M.apply()
    G.SAVE_MANAGER.save_progress = function()
        print("[BigMem] Save prevented due to disableSaving toggle.")
        return true
    end

    if G.SAVE_MANAGER.channel then
        G.SAVE_MANAGER.channel:clear()
        print("[BigMem] Save channel cleared.")
    end

    print("[BigMem] Saving disabled.")
end

function M.disable()
    if original_save_progress then
        G.SAVE_MANAGER.save_progress = original_save_progress
        print("[BigMem] Saving re-enabled.")
    end
end

return M
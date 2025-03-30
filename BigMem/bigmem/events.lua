local M = {}
local old_add_event
local AddChipsFunc = nil

function M.apply()
    if not old_add_event then old_add_event = G.E_MANAGER.add_event end

    G.E_MANAGER.add_event = function(self, e, queue)
        if not AddChipsFunc and e.func then
            -- First time we see a chips event, store the function for comparison
            if e.args and type(e.args[1]) == "number" then
                AddChipsFunc = e.func
            end
        end

        if AddChipsFunc and e.func == AddChipsFunc then
            for _, ev in ipairs(self.events or {}) do
                if ev.func == AddChipsFunc then
                    -- Combine the chip amount
                    ev.args[1] = ev.args[1] + e.args[1]
                    return ev
                end
            end
        end

        return old_add_event(self, e, queue)
    end

    print("[BigMem] Event Queue Optimization ENABLED")
end

function M.disable()
    if old_add_event then
        G.E_MANAGER.add_event = old_add_event
        print("[BigMem] Event Queue Optimization DISABLED")
    end
end

return M
local Core = {}

Core.name = "BigMem"
Core.version = "1.0.0"

Core.debug = true

function Core.log(msg)
    if Core.debug then print("[BigMem] " .. msg) end
end

-- Initialize the event queue
require("bigmem.event_queue_patch")

return Core
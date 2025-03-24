local Core = {}

Core.name = "BigMem"
Core.version = "1.0.0"

Core.debug = true

function Core.log(msg)
    if Core.debug then print("[BigMem] " .. msg) end
end

return Core
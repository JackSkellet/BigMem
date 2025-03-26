local eventQueue = {}
local events = {}

-- Add an event to the queue with priority, dependencies, and timeout
function eventQueue.addEvent(func, priority, dependencies, timeout, ...)
    table.insert(events, {
        func = func,
        priority = priority or 0,
        dependencies = dependencies or {},
        timeout = timeout or 0,
        args = {...}
    })
    print("[BigMem] Event added: " .. tostring(func) .. " with priority " .. tostring(priority))
end

-- Process all events in the queue
function eventQueue.processEvents()
    -- Sort the event queue by priority
    table.sort(events, function(a, b)
        return a.priority > b.priority
    end)

    local currentTime = love.timer.getTime()
    local executed = {}

    for _, event in ipairs(events) do
        -- Check if all dependencies are met
        local dependenciesMet = true
        for _, dep in ipairs(event.dependencies) do
            if not executed[dep] then
                dependenciesMet = false
                break
            end
        end

        -- Check if the timeout has been reached
        if dependenciesMet and (event.timeout == 0 or currentTime >= event.timeout) then
            local success, err = pcall(event.func, table.unpack(event.args))
            if success then
                executed[event.func] = true
                print("[BigMem] Event executed: " .. tostring(event.func))
            else
                print("[BigMem] Error executing event:", err)
            end
        end
    end

    events = {}
end

-- Function to get the current event queue size
function eventQueue.getQueueSize()
    return #events
end

-- Patch the existing event queue
_G.eventQueue = eventQueue
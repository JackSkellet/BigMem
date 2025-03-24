local Watcher = {}
local timeSinceLastGC = 0
local timeSinceLastCalc = 0
local calcInterval = 0.1 -- Interval for calculations in seconds
local lastFrameTime = love.timer.getTime()

function Watcher.start(config)
    local gcInterval = config.getValue("optimizeInterval") or 30
    local framerate = config.getValue("limitFramerate") or 60
    print("[BigMem] Initial GC Interval: " .. gcInterval)
    print("[BigMem] Initial Framerate Limit: " .. tostring(framerate))
    local oldUpdate = love.update or function() end

    love.update = function(dt)
        -- Update settings in case they have changed
        gcInterval = config.getValue("optimizeInterval") or 30
        framerate = config.getValue("limitFramerate") or 60

        oldUpdate(dt)
        timeSinceLastGC = timeSinceLastGC + dt
        timeSinceLastCalc = timeSinceLastCalc + dt

        if timeSinceLastGC >= gcInterval then
            collectgarbage("collect")
            timeSinceLastGC = 0
            if config.getValue("enableLogging") then
                local memUsage = collectgarbage("count")
                print("[BigMem] GC complete. Mem usage: " .. memUsage .. " KB")
                -- Adjust GC interval based on memory usage
                if memUsage > 100000 then
                    gcInterval = math.max(10, gcInterval - 5)
                else
                    gcInterval = math.min(60, gcInterval)
                end
                print("[BigMem] Adjusted GC Interval: " .. gcInterval)
            end
        end

        if timeSinceLastCalc >= calcInterval then
            -- Perform calculations here
            timeSinceLastCalc = 0
        end

        -- Limit framerate
        if framerate ~= "Unlimited" then
            local targetFrameTime = 1 / framerate
            local currentTime = love.timer.getTime()
            local frameTime = currentTime - lastFrameTime
            if frameTime < targetFrameTime then
                love.timer.sleep(targetFrameTime - frameTime)
            end
            lastFrameTime = love.timer.getTime()
        end
    end
end

return Watcher
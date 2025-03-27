local SuperBoost = {}
local BigMemConfig = require("bigmem.config")
local mathopt = require("bigmem.mathopt")

local active = false
local textBrightness = 0
local textIncreasing = true
local originalDraw = love.draw

local essential_shaders = {
    background = true,
    CRT = true,
    flame = true,
    flash = true,
    dissolve = true,
    vortex = true,
    voucher = true,
    booster = true,
    hologram = true,
    debuff = true,
    played = true,
    skew = true,
    splash = true,
}

local sprite_draw_shader = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if not BigMemConfig.getValue("drawNonEssentialShaders") and _shader == 'negative' then
        _shader = 'dissolve'
        _send = nil
    end

    if BigMemConfig.getValue("drawNonEssentialShaders") or essential_shaders[_shader] then
        return sprite_draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    end
end

local cardarea_draw = CardArea.draw
function CardArea:draw()
    if BigMemConfig.getValue("hideConsumables") and self == G.consumeables then
        return
    elseif BigMemConfig.getValue("hideDeck") and self == G.deck then
        return
    end

    return cardarea_draw(self)
end

function SuperBoost.apply(enable)
    active = enable
    if enable then 
        print("[BigMem] SUPER BOOST Activated!")

        if BigMemConfig.getValue("reduceAnimations") then
            G.SHADERS_ENABLED = false
        end

        if BigMemConfig.getValue("rainbowTint") then
            SuperBoost.toggleBRB()
        end

        -- Apply brightness setting
        SuperBoost.applyBrightness(BigMemConfig.getValue("brightness"))

    else
        print("[BigMem] SUPER BOOST Deactivated. Restoring settings...")

        -- Restore values to their normal state if needed
        G.SHADERS_ENABLED = true

        -- Restore original love.draw function if rainbow tint was enabled
        if BigMemConfig.getValue("rainbowTint") then
            love.draw = originalDraw
        end

        -- Restore default brightness (100% transparent)
        SuperBoost.applyBrightness(0)
    end
end

function SuperBoost.applyBrightness(value)
    love.draw = function()
        originalDraw()
        scaled_value = value / 100
        love.graphics.setColor(0, 0, 0, scaled_value) -- Black color with adjustable opacity
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    end
end

local originalFont = love.graphics.getFont()
local largeFont

function SuperBoost.setLargeFont(font)
    largeFont = font
end

function SuperBoost.setFontSize(size)
    if largeFont then
        largeFont:setSize(size)
    end
end

function SuperBoost.toggleBRB()
    active = not active
    if active then
        originalDraw = love.draw
        love.draw = function()
            originalDraw()
            if active then
                if textIncreasing then
                    textBrightness = textBrightness + 0.01
                    if textBrightness >= 1 then
                        textBrightness = 1
                        textIncreasing = false
                    end
                else
                    textBrightness = textBrightness - 0.01
                    if textBrightness <= 0 then
                        textBrightness = 0
                        textIncreasing = true
                    end
                end
                if largeFont then
                    love.graphics.setFont(largeFont)
                end
                -- Draw black box
                love.graphics.setColor(0, 0, 0, 0.5) -- Black box with transparency
                love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 2 - 200, love.graphics.getWidth(), 400)
                -- Draw text
                love.graphics.setColor(textBrightness, textBrightness, textBrightness, 1)
                love.graphics.push()
                love.graphics.scale(4, 4) -- Increase the text size by scaling 4 times
                love.graphics.printf("BRB", 0, love.graphics.getHeight() / 8 - 12.5, love.graphics.getWidth() / 4, "center")
                love.graphics.pop()
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.setFont(originalFont)
            end
        end
    else
        love.draw = originalDraw
    end
end

function HSVToRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0

    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end

    return r + m, g + m, b + m
end

return SuperBoost
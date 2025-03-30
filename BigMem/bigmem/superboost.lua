local SuperBoost = {}
local BigMemConfig = require("bigmem.config")

local active = false
local textBrightness = 0
local textIncreasing = true
local originalDraw = love.draw
local bigmem_original_Card_hover = Card.hover



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

        -- Apply brightness setting
        SuperBoost.applyBrightness(BigMemConfig.getValue("brightness"))

        if BigMemConfig.getValue("disableCardHoverPopup") then
            -- Override the hover function to skip hover popup
            bigmem_original_Card_hover = Card.hover
            Card.hover = function(self)
                if self.states.focus.is and not self.children.focused_ui then
                    self.children.focused_ui = G.UIDEF.card_focus_ui(self)
                end
        
                -- Don't generate popup or ability UI
                if self.facing == 'front' and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then 
                    if self.children.alert and not self.config.center.alerted then
                        self.config.center.alerted = true
                        G:save_progress()
                    end
                    Node.hover(self)
                end
            end
        end

    else
        print("[BigMem] SUPER BOOST Deactivated. Restoring settings...")

        -- Restore values to their normal state if needed
        G.SHADERS_ENABLED = true

        -- Restore default brightness (100% transparent)
        SuperBoost.applyBrightness(0)
        Card.hover = bigmem_original_Card_hover
    end
end

function SuperBoost.applyBrightness(value)
    love.draw = function()
        originalDraw()
        scaled_value = value / 100
        love.graphics.setColor(0, 0, 0, scaled_value) -- Black color with adjustable opacity
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end



return SuperBoost
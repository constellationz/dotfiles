-- A basic popup. Uses theming.

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local MAX_WIDGET_SIZE = dpi(500)
local BORDER_WIDTH = dpi(2)
local BORDER_RADIUS = dpi(8)

local popup = {
    bg = beautiful.bg_normal,
    fg = beautiful.fg_focus,
    outline = beautiful.bg_focus,
    border_width = BORDER_WIDTH,
}

-- Make a popup.
---@param popup_width number The width of this popup
---@param popup_height number The height of this popup
local function make_popup(_, popup_width, popup_height)
    local self = setmetatable({}, {__index = popup})

    -- create a new wibox
    self.wibox = wibox({
        bg = popup.bg,
        fg = popup.fg,
        border_color = popup.outline,
        border_width = popup.border_width,
        max_widget_size = MAX_WIDGET_SIZE,
        ontop = true,
        width = popup_width,
        height = popup_height,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, BORDER_RADIUS)
        end
    })

    return self
end

-- calling popup() makes a new popup
setmetatable(popup, {
    __call = make_popup
})

-- Setup the widget box
function popup:setup(...)
    self.wibox:setup(...)
end

-- Open this popup
function popup:open()
    self.wibox.visible = true
end

-- Close this popup
function popup:close()
    self.wibox.visible = false
end

return popup

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
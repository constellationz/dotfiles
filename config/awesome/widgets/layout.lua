-- Layout widget box
-- Stolen from https://awesomewm.org/doc/api/classes/awful.widget.layoutlist.html

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local popup = require("widgets.popup")
local dpi = require("beautiful").xresources.apply_dpi

local layout = {
    close_time = 1
}

-- Sizing for layout widget
local NUM_COLS = 5
local MARGINS = dpi(4)
local ICON_SPACING= dpi(5)
local ICON_WIDTH = dpi(22)
local ICON_BUTTON_WIDTH = dpi(24)

-- Remember the window positions.
---@param c table A client.
local function remember_position(c)
    c.remembered_geometry = c:geometry()
end

-- Revert all the windows to the last remembered position.
---@param c table A client.
local function restore_remembered_position(c)
    if c.remembered_geometry then
        c:geometry(c.remembered_geometry)
    end
end

-- Is this client visible?
---@param c table A client.
---@return boolean is_visible
local function visible(c)
    return c:isvisible()
end

-- Remember window positions
local function remember_window_positions()
    for c in awful.client.iterate(visible) do
        remember_position(c)
    end
end

-- Restore remembered window positions
local function restore_remembered_positions()
    for c in awful.client.iterate(visible) do
        restore_remembered_position(c)
    end
end

-- Make the layoutlist
local layout_list = awful.widget.layoutlist({
    base_layout = wibox.widget {
        spacing = ICON_SPACING,
        forced_num_cols = NUM_COLS,
        layout = wibox.layout.grid.vertical,
    },
    widget_template = {
        {
            {
                id = 'icon_role',
                forced_height = ICON_WIDTH,
                forced_width = ICON_WIDTH,
                widget = wibox.widget.imagebox,
            },
            margins = MARGINS,
            widget = wibox.container.margin,
        },
        id = 'background_role',
        forced_width = ICON_BUTTON_WIDTH,
        forced_height = ICON_BUTTON_WIDTH,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
    },
})

-- Make the popup
local layout_popup = awful.popup({
    widget = wibox.widget {
        layout_list,
        margins = MARGINS,
        widget = wibox.container.margin,
    },
    bg = popup.bg,
    fg = popup.fg,
    border_color = popup.outline,
    border_width = popup.border_width,
    placement = awful.placement.centered,
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect
})

-- Close the layout list
function layout.close()
    if layout_popup.visible then
        layout_popup.visible = false
    end
end

-- Make a timer to close this layout.
local close_timer = gears.timer({
    timeout = layout.close_time,
})
close_timer:connect_signal("timeout", layout.close)

-- Show the UI.
function layout.show()
    layout_popup.visible = true
    close_timer:again()
end

-- Increment the layout.
---@param number number The number to increment by.
function layout.inc(number)
    -- If switching from floating, remember window positions.
    if awful.layout.get() == awful.layout.suit.floating then
        remember_window_positions()
    end

    awful.layout.inc(number)

    -- If switched to floating, restore remembered positions.
    if awful.layout.get() == awful.layout.suit.floating then
        restore_remembered_positions()
    end
    layout.show()
end

-- Go to the next layout.
function layout.next()
    layout.inc(1)
end

-- Go to the previous layout.
function layout.prev()
    layout.inc(-1)
end

-- Set a layout.
---@param this_layout any The layout to use
function layout.set(this_layout)
    awful.layout.set(this_layout)
    layout.show()
end

return layout

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
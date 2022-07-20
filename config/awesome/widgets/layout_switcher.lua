-- Layout widget box
-- Stolen from https://awesomewm.org/doc/api/classes/awful.widget.layoutlist.html

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local popup = require("widgets.popup")
local dpi = require("beautiful").xresources.apply_dpi

-- Sizing for layout widget
local NUM_COLS = 5 -- The number of columns of icons
local MARGINS = dpi(4) -- Spacing around icons
local ICON_SPACING = dpi(5) -- Spacing between icons
local ICON_WIDTH = dpi(22) -- Size of icons
local ICON_BUTTON_WIDTH = dpi(24) -- Size of the buttons containing the icons

local layout_switcher = {
    close_time = 1
}

-- Make the layout list.
local layout_list = awful.widget.layoutlist {
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
}

-- Make the layout popup.
local layout_popup = awful.popup {
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
}

-- Hide the popup after the timer is run.
local close_timer = gears.timer {
    timeout = layout_switcher.close_time,
}
close_timer:connect_signal("timeout", function()
    if layout_popup.visible then
        layout_popup.visible = false
    end
end)

-- Show the layout switcher when the layout changes.
tag.connect_signal("property::layout", function(_)
    layout_popup.visible = true
    close_timer:again()
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
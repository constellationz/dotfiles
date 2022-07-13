-- User-defined statusbar.

local awful = require("awful")
local wibox = require("wibox")
local widgets = require("widgets")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local DEFAULT_HEIGHT = dpi(20)

-- Create a new statusbar on screen s.
local function create_statusbar(s)
    local statusbar_height = beautiful.statusbar_height or DEFAULT_HEIGHT

    -- Create the wibox
    s.mywibox = awful.wibar({
        height = statusbar_height,
        position = "top",
        screen = s
    })

    -- Systray widget to use
    s.systray = wibox.widget({
        {
            base_size = dpi(20),
            horizontal = true,
            screen = "primary",
            widget = wibox.widget.systray,
        },
        visible = true,
        widget = wibox.container.margin,
    })

    -- Custom widgets for the statusbar
    s.clock = require("widgets.clock").create(s)
    s.tag_list = require("widgets.tag_list").create(s)
    s.task_list = require("widgets.task_list").create(s)

    -- Keyboard layout
    s.keyboard_layout = awful.widget.keyboardlayout({})

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            widgets.launcher,
            s.tag_list,
            s.task_list,
        },

        -- Middle widget
        nil,

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            {
                s.systray,
                margins = beautiful.statusbar_margins,
                widget = wibox.container.margin,
            },
            s.keyboard_layout,
            s.clock,
            s.network,
        }
    })

    return s
end

return {
    create = create_statusbar,
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
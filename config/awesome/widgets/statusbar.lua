-- User-defined statusbar.

local awful = require("awful")
local wibox = require("wibox")
local widgets = require("widgets")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Create a new statusbar on screen s.
local function create_statusbar(s)
    -- Create the wibox
    s.mywibox = awful.wibar {
        height = beautiful.statusbar_height,
        position = "top",
        screen = s
    }

    -- Launcher widget
    s.launcher = awful.widget.launcher {
        image = beautiful.awesome_icon,
        menu = widgets.main_menu,
        margins = dpi(5)
    }

    -- Systray widget to use
    s.systray = wibox.widget {
        {
            base_size = dpi(16),
            forced_height = 20,
            horizontal = true,
            screen = "primary",
            widget = wibox.widget.systray,
        },
        spacing = 10,
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
    }

    -- Custom widgets for the statusbar
    s.clock = require("widgets.clock").create(s)
    s.taglist = require("widgets.taglist").create(s)
    s.tasklist = require("widgets.tasklist").create(s)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            s.launcher,
            s.taglist,
            s.tasklist,
        },

        -- Middle widget
        nil,

        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            spacing = beautiful.systray_spacing,
            s.systray,
            s.clock,
        }
    }

    return s
end

return {
    create = create_statusbar,
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
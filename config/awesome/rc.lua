-- Awesomewm configuration

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- To silence most linter warnings
local root = root
local client = client
local screen = screen
local awesome = awesome

-- Load awesome libraries
local tbl = require("util.tbl")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- Makes sure a window is always focused.
require("awful.autofocus")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        -- Notify user of error
        naughty.notify({
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- Printing for the execute panel
Print = function(...)
    tbl.map({...}, tostring)
    naughty.notify({
        text = table.concat({...}, " ")
    })
end

-- Define colors, icons and wallpapers.
beautiful.init(require("theme"))
beautiful.get_colors_from_wallpaper()

-- Load user-defined libraries.
local mouse = require("mouse")
local programs = require("programs")
local shortcuts = require("shortcuts")
local statusbar = require("widgets.statusbar")
local reveal = require("widgets.reveal")

-- Load user widgets
require("widgets.layout_switcher")

-- Use default icons
require("widgets.default_icons")

-- Run startup programs.
tbl.foreach(programs.startup, awful.spawn.once)

-- Export mouse sensitivity
mouse.export_sens()

-- Export repeat rate
shortcuts.export_repeat_rate()

-- Initialize the reveal module
reveal.initialize()

-- Use cool titlebars
require("cool").initialize({
    tooltips_enabled = false,
    titlebar_font = beautiful.font,
    titlebar_height = 28,
    titlebar_items = {
        left = {},
        middle = "title",
        right = {}
    }
})

-- Table of layouts to cover with awful.layout.inc
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.corner.nw,
}

-- Disable edge snapping
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

-- When screen geometry changes, set the wallpaper.
screen.connect_signal("property::geometry", beautiful.set_wallpaper)

-- Add wallpaper, tags, and statusbar to each screen.
awful.screen.connect_for_each_screen(function(s)
    beautiful.set_wallpaper(s)
    awful.tag(shortcuts.get_workspace_tags(), s, awful.layout.layouts[1])
    s.statusbar = statusbar.create(s)
end)

-- Set keys for the root.
root.keys(shortcuts.get_global_keys())

-- Toggle menu when right clicking on desktop.
root.buttons(shortcuts.root_buttons)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = shortcuts.client_keys,
            buttons = shortcuts.client_buttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen
        }
    },

    -- Certain windows should always be floating.
    {
        rule_any = {
            instance = {
                "DTA",
                "copyq",
                "pinentry"
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Sxiv",
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            name = {
                "Event Tester"
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up"
            }
        },
        properties = {
            floating = true
        }
    },

    -- Clients and dialogs get titlebars.
    {
        rule_any = {
            type = {"normal", "dialog"}
        },
        properties = {
            titlebars_enabled = true
        }
    },

    -- All floating windows open in the center of the screen.
    {
        rule_any = {
            floating = true
        },
        properties = {
            placement = awful.placement.centered
        }
    }
}

-- Signal function to execute when a new client appears.
-- Prevent clients from being unreachable after screen count changes.
client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Focus when the mouse clicks in a window.
client.connect_signal("mouse::press", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
-- Some simple widgets--[[  ]].

local awful = require("awful")
local programs = require("programs")
local beautiful = require("beautiful")

local widgets = {}

-- Drop-down menu when clicking on the awesome button.
widgets.awesome_menu = {
    {"manual", programs.terminal .. " -e man awesome"},
    {"edit config", programs.editor_cmd .. " " .. awesome.conffile},
    {"restart", awesome.restart},
    {"quit", function()
        awesome.quit()
    end}
}

-- The main menu that results from clicking on the launcher.
widgets.main_menu = awful.menu {
    items = {
        {"awesome", widgets.awesome_menu, beautiful.awesome_icon},
        {"open terminal", programs.terminal},
        {"nevermind", function()

        end}
    }
}

-- A launcher for the main menu.
return widgets

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
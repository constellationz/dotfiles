-- User shortcut configuration.

-- Awesome libraries
local client = client
local awesome = awesome
local gears = require("gears")
local awful = require("awful")
local mouse = require("mouse")
local resize = require("widgets.resize")
local layout = require("widgets.layout")
local finder = require("widgets.finder")

-- User libraries
local widgets = require("widgets")
local programs = require("programs")

-- Keys that are used in combination for other keys.
-- These can be changed for different keyboard layouts.
local meta = "Mod4"
local ctrl = "Control"
local shift = "Shift"
local esc = "Escape"
local tab = "Tab"
local space = "space"
local alt = "Mod1"

-- Repeat and delay rates (in ms)
local repeat_delay = 200
local repeat_rate = 40

-- The primary layout to use
local primary_layout = awful.layout.suit.floating

-- How many workspaces should we have?
-- Generates tags [1..workspace_count]
local workspace_count = 10

-- What mode should links be opened in?
-- Used for searchers.
-- local open_link_mode == "--new-tab"
local open_link_mode = "--new-window"

local shortcuts = {
    workspace_count = workspace_count,
    meta = meta,
    ctrl = ctrl,
    shift = shift,
    esc = esc,
    tab = tab,
    space = space
}

-- Raise a client.
---@param c table The clientto raise
---@param signal string The signal that raised the window
local function raise(c, signal)
    c:emit_signal("request::activate", signal, {raise = true})
end

-- Export the repeat rate.
function shortcuts.export_repeat_rate()
    awful.spawn(string.format(
        "xset r rate %s %s", repeat_delay, repeat_rate
    ))
end

-- Keys that are always registered
shortcuts.global_keys = {
    -- c(a)scade windows
    awful.key({meta}, "a", function()
        layout.cascade()
    end,
    {description = "cascade windows", group = "awesome"}),

    -- hi(d)e all clients
    awful.key({meta}, "d", function()
        layout.hide_all_clients()
    end,
    {description = "unminimize everything", group = "awesome"}),

    -- (s)how all clients
    awful.key({meta}, "s", function()
        layout.show_all_clients()
    end,
    {description = "unminimize everything", group = "awesome"}),

    -- switch layout
    awful.key({meta}, space, function()
        layout.next()
    end,
    {description = "next layout", group = "awesome"}),

    -- switch layout back
    awful.key({meta, shift}, space, function()
        layout.prev()
    end,
    {description = "next layout", group = "awesome"}),

    -- (r)estore layout
    awful.key({meta}, "r", function()
        layout.set(primary_layout)
        layout.restore_remembered_geometries()
    end,
    {description = "next layout", group = "awesome"}),

    -- show audio application
    awful.key({meta}, "p", function()
        awful.spawn(programs.audio)
    end,
    {description = "audio", group = "awesome"}),

    -- show (w)eb browser
    awful.key({meta}, "w", function()
        awful.spawn(programs.browser)
    end,
    {description = "browser", group = "awesome"}),

    -- show (s)creenshot
    awful.key({meta, shift}, "s", function()
        awful.spawn(programs.screenshot)
    end,
    {description = "screenshot", group = "awesome"}),

    -- (enter) a command
    awful.key({meta}, "Return", function()
        awful.spawn(programs.terminal)
    end,
    {description = "open a terminal", group = "awesome"}),

    -- (e)xplore files
    awful.key({meta}, "e", function()
        awful.spawn(programs.files)
    end,
    {description = "show files", group = "awesome"}),

    -- Go (left) one workspace
    awful.key({meta}, "Left", awful.tag.viewprev,
    {description = "view previous", group = "tag"}),

    -- Go (right) one workspace
    awful.key({meta}, "Right", awful.tag.viewnext,
    {description = "view next", group = "tag"}),

    -- Switch window focus down (vim-like)
    awful.key({meta}, "j", function()
        awful.client.focus.byidx(1)
    end,
    {description = "focus next by index", group = "client"}),

    -- Switch window focus up (vim-like)
    awful.key({meta}, "k", function()
        awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}),

    -- show (a)wesome menu
    awful.key({meta, shift}, "a", function()
        widgets.main_menu:show()
    end,
    {description = "show main menu", group = "awesome"}),

    -- swap with next client (vim-like)
    awful.key({meta, shift}, "j", function()
        awful.client.swap.byidx(1)
    end,
    {description = "swap with next client by index", group = "client"}),

    -- swap with previous client (vim-like)
    awful.key({meta, shift}, "k", function()
        awful.client.swap.byidx(-1)
    end,
    {description = "swap with previous client by index", group = "client"}),

    -- go to (u)rgent client
    awful.key({meta}, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),

    -- like alt tab, go back
    awful.key({meta}, tab, function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "go back", group = "client"}),

    -- (r)eload awesome
    awful.key({meta, ctrl}, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),

    -- make primary client bigger (vim-like)
    awful.key({meta}, "l", function()
        awful.tag.incmwfact(0.05)
    end, {description = "increase master width factor", group = "layout"}),

    -- make primary client smaller (vim-like)
    awful.key({meta}, "h", function()
        awful.tag.incmwfact(-0.05)
    end, {description = "decrease master width factor", group = "layout"}),

    --u(n)minimize and focus
    awful.key({meta, ctrl}, "n", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end
    end, {description = "restore minimized", group = "client"}),

    -- run a program.
    awful.key({alt}, space, function()
        finder.launch("run", "programs", awful.spawn)
    end,
    {description = "run prompt", group = "launcher"}),

    -- open a (c)rate
    awful.key({alt}, "c", function()
        finder.launch("search crates.io", "crates", function(text)
            local extra = (" %s crates.io/search?q=%s"):format(open_link_mode, text)
            awful.spawn(programs.browser .. extra)
        end)
    end, {description = "open crate", group = "launcher"}),

    -- find (n)pm package
    awful.key({alt}, "n", function()
        finder.launch("search npm", "crates", function(text)
            local extra = (" %s npmjs.com/search?q=%s"):format(open_link_mode, text)
            awful.spawn(programs.browser .. extra)
        end)
    end, {description = "open npm", group = "launcher"}),

    -- e(x)ecute lua code
    awful.key({alt}, "x", function()
        finder.launch("execute", "execute", awful.util.eval)
    end, {description = "lua execute prompt", group = "launcer"}),
}

-- Generate awful.keys for a workspace.
---@param i number The number of this workspace
shortcuts.workspace_keys = function(i)
    return {
        -- View a certain workspace
        awful.key({meta}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, {description = "view tag #" .. i, group = "tag"}),

        -- Show windows from many workspaces.
        awful.key({meta, "Control"}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({meta, "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, {description = "move focused client to tag #" .. i, group = "tag"}),
    }
end

-- Keys for each focused client
shortcuts.client_keys = {
    -- Close window
    awful.key({meta}, "q", function(c)
        c:kill()
    end,
    {description = "close", group = "client"}),

    -- Toggle floating
    awful.key({meta}, space, awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}),

    -- In tiled layouts, swap with master
    awful.key({ meta, shift }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "client"}),

    -- Minimize
    awful.key({meta}, "m", function(c)
        c.minimized = true
    end,
    {description = "minimize", group = "client"}),

    -- Maximize
    awful.key({meta}, "f", function(c)
        layout.toggle_maximize(c)
    end, {description = "toggle maximize", group = "client"}),

    -- Maximize vertically
    awful.key({meta}, "v", function(c)
        layout.toggle_vertical_maximize(c)
    end, {description = "toggle vertical maximize", group = "client"}),

    -- Go fullscreen
    awful.key({ meta, shift }, "f", function(c)
        layout.toggle_fullscreen(c)
    end, {description = "toggle fullscreen", group = "client"}),

    -- Move this window to the center.
    awful.key({meta}, "c", function(c)
        layout.focus(c)
    end, {description = "center", group = "client"})
}

-- Buttons when clicking on each tasklist button
shortcuts.taglist_buttons = {
    -- View only this desktop
    awful.button({}, mouse.lmb, function(t)
        t:view_only()
    end),

    -- Move the focused window to this desktop (meta + click)
    awful.button({meta}, mouse.lmb, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    -- toggle the view of this workspace
    awful.button({}, mouse.rmb, awful.tag.viewtoggle),
}

-- When clicking on the taskbar
shortcuts.tasklist_buttons = {
    -- always focus when clicking on something
    awful.button({}, mouse.lmb, function(c)
        if client.focus ~= c then
            c:emit_signal("request::activate", "tasklist", {raise = true})
        else
            c.minimized = not c.minimized
        end
    end),
}

-- Buttons for clicking on the client.
shortcuts.client_buttons = {
    awful.button({}, mouse.lmb, function(c)
        raise(c, "mouse_click")
    end),
    awful.button({meta}, mouse.lmb, function(c)
        raise(c, "mouse_click")
        awful.mouse.client.move(c)
    end),
    awful.button({meta}, mouse.rmb, function(c)
        raise(c, "mouse_click")
        resize.resize_client(c)
    end)
}

-- Buttons for clicking on the desktop.
shortcuts.root_buttons = {
    awful.button({}, mouse.rmb, function()
        widgets.main_menu:show()
    end)
}

-- Get the global_keys, generated from shortcuts and workspaces.
---@return table globalkeys
function shortcuts.get_global_keys()
    local globalkeys = gears.table.join(table.unpack(shortcuts.global_keys))
    for i = 1, shortcuts.workspace_count do
        globalkeys = gears.table.join(globalkeys, table.unpack(shortcuts.workspace_keys(i)))
    end
    return globalkeys
end

-- Get tags from workspaces, generated from shortcuts.workspace_count
---@return table tags
function shortcuts.get_workspace_tags()
    local tags = {}
    for i = 1, workspace_count do
        tags[i] = tostring(i)
    end
    return tags
end

return shortcuts

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
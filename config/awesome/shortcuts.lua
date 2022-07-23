-- User shortcut configuration.

-- Awesome libraries
local client = client
local awesome = awesome
local gears = require("gears")
local awful = require("awful")
local mouse = require("mouse")
local layout = require("layout")
local resize = require("widgets.resize")
local finder = require("widgets.finder")
local fuzzy_switcher = require("widgets.fuzzy_switcher")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Don't show tmux keys!
package.loaded["awful.hotkeys_popup.keys.tmux"] = {}

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- User libraries
local widgets = require("widgets")
local programs = require("programs")

-- Keys that are used in combination for other keys.
-- These can be changed for different keyboard layouts.
local meta = "Mod4" -- Used for window management
local ctrl = "Control"
local shift = "Shift" -- Used to modify window management
local tab = "Tab"
local space = "space" -- Search
local alt = "Mod1" -- Modifier for some functions

-- The increment for resize_inc (in pixels)
local resize_inc_amount = 100

-- Repeat and delay rates (in ms)
local repeat_delay = 200
local repeat_rate = 40

-- The primary layout to use
local primary_layout = awful.layout.suit.floating

-- How many workspaces should we have?
-- Generates tags [1..workspace_count]
local workspace_count = 10

-- Query a duckduckgo bang search
---@param text string The text to query
local function bang(text)
    if not text then
        return
    end
    local url_text = text:gsub(" ", "\\ ")
    local query = ("duckduckgo.com/?q=%s"):format(url_text)
    programs.open_link(query)
end

-- Export the repeat rate.
local function export_repeat_rate()
    awful.spawn(string.format(
        "xset r rate %s %s", repeat_delay, repeat_rate
    ))
end

-- Keys that are always registered
local global_keys = {
    -- show hotke(y)s
    awful.key({meta}, "y", hotkeys_popup.show_help,
    {description = "show hotkeys", group = "awesome"}),

    -- casc(a)de windows
    awful.key({meta}, "a", function()
        layout.cascade()
    end,
    {description = "cascade windows", group = "awesome"}),

    -- raise brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("backlight_control +10")
    end,
    {description = "raise brightness", group = "awesome"}),

    -- lower brightness
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("backlight_control -10")
    end,
    {description = "lower brightness", group = "awesome"}),

    -- raise volume
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("amixer set Master 2.5%+")
    end,
    {description = "raise volume", group = "awesome"}),

    -- lower volume
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("amixer set Master 2.5%-")
    end,
    {description = "lower volume", group = "awesome"}),

    -- toggle volume mute
    awful.key({}, "XF86AudioMute", function()
        awful.spawn("amixer set Master toggle")
    end,
    {description = "toggle volume mute", group = "awesome"}),

    -- toggle microphone mute
    awful.key({}, "XF86AudioMicMute", function()
        awful.spawn("amixer set Capture toggle")
    end,
    {description = "toggle microphone mute", group = "awesome"}),

    -- edit (n)etwork connections
    awful.key({meta}, "n", function()
        awful.spawn(programs.network)
    end,
    {description = "edit network connections", group = "programs"}),

    -- open (b)lueman
    awful.key({meta}, "b", function()
        awful.spawn(programs.blueman)
    end,
    {description = "open blueman", group = "programs"}),

    -- hi(d)e all clients
    awful.key({meta}, "d", function()
        layout.hide_all_clients()
    end,
    {description = "hide all clients", group = "awesome"}),

    -- (s)how all clients
    awful.key({meta}, "s", function()
        layout.show_all_clients()
    end,
    {description = "show all clients", group = "awesome"}),

    -- switch to next layout
    awful.key({meta}, space, function()
        layout.next_layout()
    end,
    {description = "switch to next layout", group = "awesome"}),

    -- switch to previous layout
    awful.key({meta, shift}, space, function()
        layout.prev_layout()
    end,
    {description = "switch to previous layout", group = "awesome"}),

    -- (r)estore remembered layout
    awful.key({meta}, "r", function()
        awful.layout.set(primary_layout)
        layout.restore_remembered_geometries()
    end,
    {description = "restore remembered layout", group = "awesome"}),

    -- open (p)avucontrol
    awful.key({meta}, "p", function()
        awful.spawn(programs.audio)
    end,
    {description = "open pavucontrol", group = "programs"}),

    -- open (w)eb browser
    awful.key({meta}, "w", function()
        awful.spawn(programs.browser)
    end,
    {description = "open web browser", group = "programs"}),

    -- take screensho(t)
    awful.key({meta}, "t", function()
        awful.spawn(programs.screenshot)
    end,
    {description = "take screenshot", group = "programs"}),

    -- open a terminal
    awful.key({meta}, "Return", function()
        awful.spawn(programs.terminal)
    end,
    {description = "open a terminal", group = "programs"}),

    -- (e)xplore files
    awful.key({meta}, "e", function()
        awful.spawn(programs.files)
    end,
    {description = "explore files", group = "programs"}),

    -- open fold(e)r
    awful.key({meta, shift}, "e", function()
        awful.spawn(programs.find_folder)
    end,
    {description = "open folder", group = "programs"}),

    -- go (left) one workspace
    awful.key({meta}, "Left", awful.tag.viewprev,
    {description = "go left one workspace", group = "tag"}),

    -- go (right) one workspace
    awful.key({meta}, "Right", awful.tag.viewnext,
    {description = "go right one workspace", group = "tag"}),

    -- go (down) a window
    awful.key({meta}, "j", function()
        awful.client.focus.byidx(1)
    end,
    {description = "go down a window", group = "awesome"}),

    -- go (up) a window
    awful.key({meta}, "k", function()
        awful.client.focus.byidx(-1)
    end,
    {description = "go up a window", group = "awesome"}),

    -- show (a)wesome menu
    awful.key({meta, shift}, "a", function()
        widgets.main_menu:show()
    end,
    {description = "show awesome menu", group = "awesome"}),

    -- swap with (next) client
    awful.key({meta, shift}, "j", function()
        awful.client.swap.byidx(1)
    end,
    {description = "swap with next client", group = "client"}),

    -- swap with (previous) client
    awful.key({meta, shift}, "k", function()
        awful.client.swap.byidx(-1)
    end,
    {description = "swap with previous client", group = "client"}),

    -- go to (u)rgent client
    awful.key({meta}, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "awesome"}),

    -- quick switch windows
    awful.key({meta}, tab, fuzzy_switcher.launch,
    {description = "quick switch", group = "awesome"}),

    -- (r)eload awesome
    awful.key({meta, ctrl}, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),

    -- make primary client bigger (vim-like)
    awful.key({meta}, "l", function()
        if not layout.is_floating() then
            awful.tag.incmwfact(0.05)
        else
            layout.resize_inc(client.focus, resize_inc_amount)
        end
    end, {description = "increase master width factor", group = "awesome"}),

    -- make primary client smaller (vim-like)
    awful.key({meta}, "h", function()
        if not layout.is_floating() then
            awful.tag.incmwfact(-0.05)
        else
            layout.resize_inc(client.focus, -resize_inc_amount)
        end
    end, {description = "decrease master width factor", group = "awesome"}),

    -- run a program.
    awful.key({alt}, space, function()
        finder.launch("run", "programs", awful.spawn)
    end,
    {description = "run prompt", group = "launcher"}),


    -- duckduckgo b(a)ng!
    awful.key({alt}, "a", function()
        finder.launch("search", "search", bang)
    end, {description = "open duckduckgo", group = "launcher"}),

    -- e(x)ecute lua code
    awful.key({alt}, "x", function()
        finder.launch("execute", "execute", awful.util.eval)
    end, {description = "execute lua", group = "launcher"})
}

-- Generate awful.keys for a workspace.
---@param i number The number of this workspace
local function get_workspace_keys(i)
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
local client_keys = {
    -- Close window
    awful.key({meta}, "q", function(c)
        c:kill()
    end,
    {description = "close", group = "client"}),

    -- automatically ch(o)ose the current client's color
    awful.key({meta}, "o", function(c)
        c:emit_signal("autocolor")
    end,
    {description = "automatically color titlebar", group = "awesome"}),

    -- reset window c(O)lor
    awful.key({meta, shift}, "o", function(c)
        c:emit_signal("resetcolor")
    end,
    {description = "reset titlebar color", group = "awesome"}),

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

    -- Move this window to the (c)enter.
    awful.key({meta}, "c", function(c)
        awful.placement.centered(c)
    end, {description = "center", group = "client"}),

    -- Bring this window to the front and center
    awful.key({meta}, "x", function(c)
        if not layout.is_floating() then
            layout.cascade()
        end
        layout.front_and_center(c)
    end, {description = "focus", group = "client"})
}

-- Buttons when clicking on each tasklist button
local taglist_buttons = {
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
local tasklist_buttons = {
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
local client_buttons = {
    awful.button({}, mouse.lmb, function(c)
        layout.activate(c, "mouse_click")
    end),
    awful.button({meta}, mouse.lmb, function(c)
        layout.activate(c, "mouse_click")
        awful.mouse.client.move(c)
    end),
    awful.button({meta}, mouse.rmb, function(c)
        layout.activate(c, "mouse_click")
        resize.resize_client(c)
    end)
}

-- Buttons for clicking on the desktop.
local root_buttons = {
    awful.button({}, mouse.rmb, function()
        widgets.main_menu:show()
    end)
}

-- Get the global_keys, generated from shortcuts and workspaces.
---@return table globalkeys
local function get_global_keys()
    local globalkeys = gears.table.join(table.unpack(global_keys))
    for i = 1, workspace_count do
        globalkeys = gears.table.join(globalkeys, table.unpack(get_workspace_keys(i)))
    end
    return globalkeys
end

-- Get tags from workspaces, generated from shortcuts.workspace_count
---@return table tags
local function get_workspace_tags()
    local tags = {}
    for i = 1, workspace_count do
        tags[i] = tostring(i)
    end
    return tags
end

return {
    get_global_keys = get_global_keys,
    get_workspace_tags = get_workspace_tags,
    export_repeat_rate = export_repeat_rate,
    client_keys = client_keys,
    taglist_buttons = taglist_buttons,
    tasklist_buttons = tasklist_buttons,
    root_buttons = root_buttons,
    client_buttons = client_buttons,
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
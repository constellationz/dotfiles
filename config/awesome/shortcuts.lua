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

-- The increment for resize_inc (in pixels)
local resize_inc_amount = 25

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
-- local open_link_mode = "--new-window"
local open_link_mode = "--new-tab"

local shortcuts = {
    workspace_count = workspace_count,
    meta = meta,
    ctrl = ctrl,
    shift = shift,
    esc = esc,
    tab = tab,
    space = space
}

-- Is the current layout floating?
---@return boolean is_floating
local function is_floating()
    return awful.layout.get() == awful.layout.suit.floating
end

-- Focus the previous window.
local function focus_previous()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

-- Increment the size of a floating window.
---@param c table The client to resize
---@param inc number The increment to use for the size.
local function resize_inc(c, inc)
    -- Do nothing for nil clients.
    if c == nil then
        return
    end

    -- Get old sizes
    local geometry = c:geometry()

    -- Calculate new size
    -- Resize using an aspect ratio for consistency
    local height = geometry.height + inc
    local width = height * 4 / 3
    local x = geometry.x + (geometry.width - width) / 2
    local y = geometry.y + (geometry.height - height) / 2

    -- Don't resize if the window will be too big.
    local screen = c.screen
    if inc > 0 and (width > screen.geometry.width or height > screen.geometry.height) then
        return
    end

    -- Don't resize if the window will be too small.
    if inc < 0 and (width < 500 or height < 500) then
        return
    end

    c:geometry({
        x = x,
        y = y,
        width = width,
        height = height,
    })
end

-- Move a client to the side.
---@param c table The client to move.
local scooch_left = true
local function scooch(c)
    if c == nil then
        return
    end

    -- Get geometry information.
    local screen_geometry = c.screen.geometry
    local geometry = c:geometry()
    local width = geometry.width
    local height = geometry.height

    -- Pick a height to place the window at.
    local y = (screen_geometry.height - geometry.height) / 2

    c:geometry({
        width = width,
        height = height,
        x = scooch_left and 0 or screen_geometry.width - width,
        y = y
    })

    scooch_left = not scooch_left
end

-- Make the focus bigger.
local function make_focus_bigger()
    if not is_floating() then
        awful.tag.incmwfact(0.05)
    else
        resize_inc(client.focus, resize_inc_amount)
    end
end

-- Make the focus smaller.
local function make_focus_smaller()
    if not is_floating() then
        awful.tag.incmwfact(-0.05)
    else
        resize_inc(client.focus, -resize_inc_amount)
    end
end


-- Query a duckduckgo bang search
---@param text string The text to query
local function bang(text)
    if not text then
        return
    end
    local url_text = text:gsub(" ", "\\ ")
    local query = (" %s duckduckgo.com/?q=%s"):format(open_link_mode, url_text)
    awful.spawn(programs.browser .. query)
end

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

    -- raise brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("backlight_control +10")
    end,
    {description = "lower brightness", group = "awesome"}),

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

    -- Edit (n)etwork connections
    awful.key({meta}, "n", function()
        awful.spawn(programs.network)
    end,
    {description = "edit network connections", group = "awesome"}),

    -- Open (b)lueman
    awful.key({meta}, "b", function()
        awful.spawn(programs.blueman)
    end,
    {description = "open blueman", group = "awesome"}),

    -- hi(d)e all clients
    awful.key({meta}, "d", function()
        layout.toggle_clients_hidden()
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
        focus_previous()
    end,
    {description = "go back", group = "client"}),

    -- (r)eload awesome
    awful.key({meta, ctrl}, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),

    -- make primary client bigger (vim-like)
    awful.key({meta}, "l", function()
        make_focus_bigger()
    end, {description = "increase master width factor", group = "layout"}),

    -- make primary client smaller (vim-like)
    awful.key({meta}, "h", function()
        make_focus_smaller()
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


    -- duckduckgo b(a)ng!
    awful.key({alt}, "a", function()
        finder.launch("search", "search", bang)
    end, {description = "open duckduckgo", group = "launcher"}),

    -- e(x)ecute lua code
    awful.key({alt}, "x", function()
        finder.launch("execute", "execute", awful.util.eval)
    end, {description = "lua execute prompt", group = "launcher"})
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

    -- (s)cooch this window to the side
    awful.key({meta}, "s", function(c)
        scooch(c)
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

    -- Move this window to the center.
    awful.key({meta}, "c", function(c)
        if not is_floating() then
            layout.cascade()
        end
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
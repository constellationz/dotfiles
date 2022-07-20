-- Functions that deal with layouts.

local tbl = require("tbl")
local awful = require("awful")
local dpi = require("beautiful").xresources.apply_dpi

-- Cascade options
local CASCADE_START = dpi(50) -- Distance from corner
local CASCADE_OFFSET = dpi(50) -- Distance to next window
local MAX_CASCADE_WIDTH = dpi(1200) -- Distance from corner
local MAX_CASCADE_HEIGHT = dpi(800) -- Distance to next window

-- Resize options
local MIN_CLIENT_SIZE = 500 -- Minimum client size
local RESIZE_ASPECT_RATIO = 4 / 3 -- The aspect ratio of resized clients

-- Options for center maximizing
local FOCUS_WIDTH = dpi(1500) -- Width of focused window

-- Clamp a value between a min and max.
---@param value number The value to clamp.
---@param min number The minimum value to clamp to.
---@param max number The maximim value to clamp to.
---@return number clamped_value
local function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

-- Is this client visible?
---@param c table A client.
---@return boolean is_visible
local function visible(c)
    return c:isvisible()
end

-- Only iterate over clients whose tags are visible
---@param c any The client we are iterating over
local function this_workspace(c)
    for _, tag in pairs (awful.tag.selectedlist()) do
        if tbl.has(c, tag:clients()) then
            return true
        end
    end
    return false
end

-- Get the usable geometry of a screen
---@param screen table The screen to ge the geometry of
---@return table geometry The geometry of this screen.
local function get_screen_geometry(screen)
    return screen:get_bounding_geometry {
        honor_workarea = true,
    }
end

-- Remember the window positions.
---@param c table A client.
local function remember_geometry(c)
    c.remembered_geometry = c:geometry()
end

-- Revert all the windows to the last remembered position.
---@param c table A client.
local function restore_remembered_geometry(c)
    if c.remembered_geometry then
        c:geometry(c.remembered_geometry)
    end
end

-- Remember window positions
local function remember_window_geometries()
    for c in awful.client.iterate(visible) do
        remember_geometry(c)
    end
end

-- Restore remembered window positions
local function restore_remembered_geometries()
    for c in awful.client.iterate(visible) do
        restore_remembered_geometry(c)
    end
end

-- Set the geometry of a cLient and make sure it's confined.
---@param c any client The client to set the geometry of
local function confine(c)
    local screen_geometry = get_screen_geometry(c.screen)
    local geometry = c:geometry()
    local new_x = geometry.x
    local new_y = geometry.y

    -- Confine x
    if geometry.x < screen_geometry.x then
        new_x = screen_geometry.x
    elseif geometry.x + geometry.width > screen_geometry.x + screen_geometry.width then
        new_x = screen_geometry.width - geometry.width
    end

    -- Confine y
    if geometry.y < screen_geometry.y then
        new_y = screen_geometry.y
    elseif geometry.y + geometry.height > screen_geometry.y + screen_geometry.height then
        new_y = screen_geometry.height - geometry.height
    end

    c:geometry {
        x = new_x,
        y = new_y,
    }
end

-- Show every client.
local function show_all_clients()
    for c in awful.client.iterate(this_workspace) do
        c.minimized = false
    end
end

-- Hide every client.
local function hide_all_clients()
    for c in awful.client.iterate(this_workspace) do
        c.minimized = true
    end
end

-- Activate a client.
---@param c table The client to activate
---@param signal string The signal that activated the window
local function activate(c, signal)
    c:emit_signal("request::activate", signal, {raise = true})
end

-- restore a window.
---@param c any The client to restore.
local function restore(c)
    -- Restore the window
    c.fullscreen = false
    c.maximized = false
    c.maximized_vertical = false
    c.maximized_horizontal = false
    c:raise()
end

-- Focus the previous window.
local function focus_previous()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end

-- Make a window fullscreen.
---@param c any The client to make fullscreen.
local function fullscreen(c)
    restore(c)
    c.fullscreen = true
    c:raise()
end

-- Make a window maximized.
---@param c any The client to make maximized.
local function maximize(c)
    restore(c)
    c.maximized = true
    c:raise()
end

-- Maximize a client vertically
-- Changes the width to be a readable size.
---@param c any The client to maximize vertically
local function maximize_vertically(c)
    restore(c)
    c.maximized_vertical = true
    c:raise()
end

-- Bring a window front and center
---@param c any The client to focus.
local function front_and_center(c)
    restore(c)
    c:geometry({
        width = dpi(FOCUS_WIDTH),
    })
    awful.placement.centered(c)
    maximize_vertically(c)
    c:raise()
end

-- Toggle fullscreen on a window.
---@param c any The client to toggle fullscreen.
local function toggle_fullscreen(c)
    if c.fullscreen then
        restore(c)
    else
        fullscreen(c)
    end
end

-- Toggle maximize for a client.
---@param c any The client to toggle maximize for
local function toggle_maximize(c)
    if c.maximized then
        restore(c)
    else
        maximize(c)
    end
end

-- Toggle vertical maximize for a client.
---@param c any The client to toggle vertical maximize for
local function toggle_vertical_maximize(c)
    if c.maximized_vertical then
        restore(c)
    else
        maximize_vertically(c)
    end
end

-- Iterate over windows by size.
---@param iterator function The iterator to use
local function by_size(iterator)
    local windows_by_size = {}
    for c in iterator do
        windows_by_size[#windows_by_size + 1] = c
    end
    table.sort(windows_by_size, function(a, b)
        local a_area = a:geometry().width * a:geometry().height
        local b_area = b:geometry().width * b:geometry().height
        return a_area > b_area
    end)
    return ipairs(windows_by_size)
end

-- Cascade every visible window.
local function cascade()
    -- Use a floating layout
    awful.layout.set(awful.layout.suit.floating)

    -- Remember where the windows were before cascading.
    remember_window_geometries()

    -- Cascade the windows.
    local current_offset = CASCADE_START
    for _, c in by_size(awful.client.iterate(this_workspace)) do
        restore(c)
        local geometry = c:geometry()
        c:geometry {
            x = current_offset,
            y = current_offset,
            width = math.min(geometry.width, MAX_CASCADE_WIDTH),
            height = math.min(geometry.height, MAX_CASCADE_HEIGHT),
        }
        confine(c)
        c:raise()
        current_offset = current_offset + CASCADE_OFFSET
    end
end

-- Increment the size of a floating window.
-- Resize using an aspect ratio
---@param c table The client to resize
---@param inc number The increment to use for the size.
local function resize_inc(c, inc)
    -- Do nothing for nil clients.
    if c == nil then
        return
    end

    -- Get geometries
    local geometry = c:geometry()
    local screen_geometry = get_screen_geometry(c.screen)

    -- Calculate new height and width
    local height = clamp(geometry.height + inc,
        MIN_CLIENT_SIZE,
        screen_geometry.height
    )
    local width = clamp(height * RESIZE_ASPECT_RATIO,
        MIN_CLIENT_SIZE,
        screen_geometry.width
    )

    restore(c)
    c:geometry {
        width = width,
        height = height
    }
    awful.placement.centered(c)
    confine(c)
end

-- Move a client to the side.
---@param c table The client to move.
---@param scooch_left boolean Should the window scooch right?
local function scooch(c, scooch_left)
    if c == nil then
        return
    end

    -- Get geometry information.
    local geometry = c:geometry()
    local screen_geometry = get_screen_geometry(c.screen)

    c:geometry {
        x = scooch_left and 0 or screen_geometry.width - geometry.width,
    }
end

-- Is the current layout floating?
---@return boolean is_floating
local function is_floating()
    return awful.layout.get() == awful.layout.suit.floating
end

-- Set a layout.
---@param this_layout any The layout to use
local function set_layout(this_layout)
    awful.layout.set(this_layout)
end

-- Increment the layout.
---@param number number The number to increment by.
local function inc_layout(number)
    -- If switching from floating, remember window positions.
    if is_floating() then
        remember_window_geometries()
    end

    awful.layout.inc(number)

    -- If switched to floating, restore remembered positions.
    if is_floating() then
        restore_remembered_geometries()
    end
end

-- Go to the next layout.
local function next_layout()
    inc_layout(1)
end

-- Go to the previous layout.
local function prev_layout()
    inc_layout(-1)
end

return {
    restore_remembered_geometries = restore_remembered_geometries,
    remember_window_geometries = remember_window_geometries,
    show_all_clients = show_all_clients,
    hide_all_clients = hide_all_clients,
    activate = activate,
    restore = restore,
    focus_previous,
    fullscreen = fullscreen,
    maximize = maximize,
    maximize_vertically = maximize_vertically,
    toggle_fullscreen = toggle_fullscreen,
    toggle_maximize = toggle_maximize,
    toggle_vertical_maximize = toggle_vertical_maximize,
    front_and_center = front_and_center,
    cascade = cascade,
    confine = confine,
    scooch = scooch,
    resize_inc = resize_inc,
    is_floating = is_floating,
    set_layout = set_layout,
    inc_layout = inc_layout,
    next_layout = next_layout,
    prev_layout = prev_layout,
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
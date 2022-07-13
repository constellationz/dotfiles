-- Layout widget box
-- Stolen from https://awesomewm.org/doc/api/classes/awful.widget.layoutlist.html

local tbl = require("tbl")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local popup = require("widgets.popup")
local dpi = require("beautiful").xresources.apply_dpi

local layout = {
    close_time = 1
}

-- Options for cascading
local CASCADE_START = dpi(50) -- Distance from corner
local CASCADE_OFFSET = dpi(50) -- Distance to next window
local MAX_CASCADE_WIDTH = dpi(1200) -- Distance from corner
local MAX_CASCADE_HEIGHT = dpi(800) -- Distance to next window

-- Options for center maximizing
local FOCUS_WIDTH = dpi(1500)
local FOCUS_HEIGHT = dpi(950)

-- Sizing for layout widget
local NUM_COLS = 5
local MARGINS = dpi(4)
local ICON_SPACING = dpi(5)
local ICON_WIDTH = dpi(22)
local ICON_BUTTON_WIDTH = dpi(24)

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

-- Iterator for everything
-- local function everything(_)
--     return true
-- end

-- Remember the window positions.
---@param c table A client.
function layout.remember_geometry(c)
    c.remembered_geometry = c:geometry()
end

-- Revert all the windows to the last remembered position.
---@param c table A client.
function layout.restore_remembered_geometry(c)
    if c.remembered_geometry then
        c:geometry(c.remembered_geometry)
    end
end

-- Remember window positions
function layout.remember_window_geometries()
    for c in awful.client.iterate(visible) do
        layout.remember_geometry(c)
    end
end

-- Restore remembered window positions
function layout.restore_remembered_geometries()
    for c in awful.client.iterate(visible) do
        layout.restore_remembered_geometry(c)
    end
end

-- Show every client.
function layout.show_all_clients()
    for c in awful.client.iterate(this_workspace) do
        c.minimized = false
    end
end

-- Hide every client.
function layout.hide_all_clients()
    for c in awful.client.iterate(this_workspace) do
        c.minimized = true
    end
end

-- Hide every client.
local is_hidden = false
function layout.toggle_clients_hidden()
    if is_hidden then
        layout.show_all_clients()
    else
        layout.hide_all_clients()
    end
    is_hidden = not is_hidden
end

-- Unmaximize a window.
---@param c any The client to unmaximize.
function layout.unmaximize(c)
    c.maximized = false
    c.fullscreen = false
    c.maximized_vertical = false
    c:raise()
end

-- Make a window maximized.
---@param c any The client to make maximized.
function layout.maximize(c)
    layout.unmaximize(c)
    c.maximized = true
    c:raise()
end

-- Make a window fullscreen.
---@param c any The client to make fullscreen.
function layout.fullscreen(c)
    layout.unmaximize(c)
    c.fullscreen = true
    c:raise()
end

-- Focus a window.
---@param c any The client to focus.
function layout.focus(c)
    layout.unmaximize(c)
    c:geometry({
        x = 0,
        y = 0,
        width = dpi(FOCUS_WIDTH),
        height = dpi(FOCUS_HEIGHT),
    })
    awful.placement.centered(c)
    c:raise()
end

-- Maximize a client vertically
-- Changes the width to be a readable size.
---@param c any The client to maximize vertically
function layout.maximize_vertically(c)
    layout.unmaximize(c)
    c.maximized_vertical = true
    c:raise()
end

-- Toggle maximize for a client.
---@param c any The client to toggle maximize for
function layout.toggle_maximize(c)
    c.maximized = not c.maximized
    if c.maximized then
        layout.maximize(c)
    else
        layout.unmaximize(c)
    end
end

-- Toggle fullscreen on a window.
---@param c any The client to toggle fullscreen.
function layout.toggle_fullscreen(c)
    c.fullscreen = not c.fullscreen
    if c.fullscreen then
        layout.fullscreen(c)
    else
        layout.unmaximize(c)
    end
end

-- Toggle vertical maximize for a client.
---@param c any The client to toggle vertical maximize for
function layout.toggle_vertical_maximize(c)
    c.maximize_vertical = not c.maximize_vertical
    if c.maximize_vertical then
        layout.maximize_vertically(c)
    else
        layout.unmaximize(c)
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
function layout.cascade()
    -- Use a floating layout.
    awful.layout.set(awful.layout.suit.floating)

    -- Remember where the windows were before cascading.
    layout.remember_window_geometries()

    -- Cascade the windows.
    local current_offset = CASCADE_START
    for _, c in by_size(awful.client.iterate(this_workspace)) do
        layout.unmaximize(c)
        local geometry = c:geometry()
        c:geometry({
            x = current_offset,
            y = current_offset,
            width = math.min(geometry.width, MAX_CASCADE_WIDTH),
            height = math.min(geometry.height, MAX_CASCADE_HEIGHT),
        })
        c:raise()
        current_offset = current_offset + CASCADE_OFFSET
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
        layout.remember_window_geometries()
    end

    awful.layout.inc(number)

    -- If switched to floating, restore remembered positions.
    if awful.layout.get() == awful.layout.suit.floating then
        layout.restore_remembered_geometries()
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
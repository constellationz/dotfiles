-- Author: mu-tex
-- License: MIT
-- Forked by constellationz into cool, thanks mu-tex!

-- Some constants
local MAX_TITLE_LEN = 90
local TITLE_COLOR_DARK = "#242424"
local TITLE_COLOR_LIGHT = "#fefefa"
local BOTTOM_EDGE_HEIGHT = 5
local STROKE_WIDTH_OUTER = 2
local STROKE_WIDTH_INNER = 2
local TITLE_UNFOCUSED_OPACITY = 0.7
local OUTER_TRANSPARENCY = "FF"
local INNER_TRANSPARENCY = "00"

-- Mouse buttons
local MB_LEFT = 1
local MB_MIDDLE = 2
local MB_RIGHT = 3

-- To silence linter warnings
local client = client
local screen = screen
local mousegrabber = mousegrabber

-- Require awesome libraries
local awful = require("awful")
local beautiful = require("beautiful")
local gtimer = require("gears.timer")
local wibox = require("wibox")
local gears = require("gears")
local get_font_height = require("beautiful").get_font_height

-- Gears timer
local lgi = require("lgi")
local gdk = lgi.require("Gdk", "3.0")
local get_default_root_window = gdk.get_default_root_window
local pixbuf_get_from_window = gdk.pixbuf_get_from_window

-- Aliases for wibox
local textbox = wibox.widget.textbox
local imagebox = wibox.widget.imagebox
local wcontainer = wibox.container
local wcontainer_background = wcontainer.background
local wcontainer_constraint = wcontainer.constraint
local wcontainer_margin = wcontainer.margin
local wcontainer_place = wcontainer.place

-- Get colors
local colors = require("cool.colors")
local darken = colors.darken
local lighten = colors.lighten
local is_contrast_acceptable = colors.is_contrast_acceptable
local relative_luminance = colors.relative_luminance

-- Get shapes
local shapes = require("cool.shapes")
local create_corner_top_left = shapes.create_corner_top_left
local create_edge_left = shapes.create_edge_left
local create_edge_top_middle = shapes.create_edge_top_middle
local color = shapes.color

-- Table information
local cool_table = require("cool.table")

-- Load the color rules or create an empty table if there aren't any
local gfilesys = require("gears.filesystem")
local config_dir = gfilesys.get_configuration_dir()
local color_rules_filename = "color_rules"
local color_rules_filepath = config_dir .. "/cool/" .. color_rules_filename

gdk.init({})

-- => Defaults
-- ============================================================
local _private = {}
_private.max_width = 0
_private.max_height = 0

-- Titlebar
_private.titlebar_height = 38
_private.titlebar_radius = 8
_private.titlebar_color = beautiful.bg_normal -- "#1E1E24"
_private.titlebar_margin_left = 0
_private.titlebar_margin_right = 0
_private.titlebar_font = beautiful.font_face .. " 11" -- "Sans 11"
_private.color_rules = cool_table.load(color_rules_filepath) or {}
_private.titlebar_items = {
    left = {"close", "minimize", "maximize"},
    middle = "title",
    right = {"sticky", "ontop", "floating"},
}
_private.context_menu_theme = {
    bg_focus = "#aed9e0",
    bg_normal = "#5e6472",
    border_color = "#00000000",
    border_width = 0,
    fg_focus = "#242424",
    fg_normal = "#fefefa",
    font = "Sans 11",
    height = 27.5,
    width = 250,
}

-- no titlebar when maximized
_private.no_titlebar_maximized = true
_private.mb_move = MB_LEFT
_private.mb_contextmenu = MB_RIGHT

-- Titlebar Items
_private.button_size = 16
_private.button_margin_horizontal = 5
_private.button_margin_top = 2
_private.tooltips_enabled = true
_private.tooltip_messages = {
    close = "close",
    minimize = "minimize",
    maximize_active = "unmaximize",
    maximize_inactive = "maximize",
    floating_active = "enable tiling mode",
    floating_inactive = "enable floating mode",
    ontop_active = "don't keep above other windows",
    ontop_inactive = "keep above other windows",
    sticky_active = "disable sticky mode",
    sticky_inactive = "enable sticky mode",
}
_private.close_color = "#ee4266"
_private.minimize_color = "#ffb400"
_private.maximize_color = "#4CBB17"
_private.floating_color = "#f6a2ed"
_private.ontop_color = "#f6a2ed"
_private.sticky_color = "#f6a2ed"

-- Lighten a luminance.
---@param lum number
---@return number new_lum
local function rel_lighten(lum)
    return lum * 90 + 10
end

-- Darken a luminance.
---@param lum number
---@return number new_lum
local function rel_darken(lum)
    return -(lum * 70) + 100
end

-- Saves the contents of _private.color_rules table to file
local function save_color_rules()
    cool_table.save(_private.color_rules, color_rules_filepath)
end

-- Adds a color rule entry to the color_rules table for the given client and saves to file
---@param c any The client to set the color rule of.
---@param color any The color to give the client.
local function set_color_rule(c, color)
    _private.color_rules[c.instance] = color
    save_color_rules()
end

-- Fetches the color rule for the given client instance
---@param c any The client to get the color rule from
---@return any color_rule
local function get_color_rule(c)
    return _private.color_rules[c.instance]
end

-- Returns the hex color for the pixel at the given coordinates on the screen
---@param x number
---@param y number
---@return string hex
local function get_pixel_at(x, y)
    local pixbuf = pixbuf_get_from_window(get_default_root_window(), x, y, 1, 1)
    local bytes = pixbuf:get_pixels()
    return "#" .. bytes:gsub(".", function(c) return ("%02x"):format(c:byte()) end)
end

-- Set the dominant color of a client.
---@param c any The client to set the dominant color of.
---@return any dominant_color The dominant color.
local function auto_set_dominant_color(c)
    local dominant_color = colors.get_dominant_color(gears.surface(c.content), c:geometry().width)
    set_color_rule(c, dominant_color)
    return dominant_color
end

-- Returns a color that is analogous to the last color returned
-- To make sure that the "randomly" generated colors look cohesive, only the first color is truly random, the rest are generated by offseting the hue by +33 degrees
---@return string random_hex
local next_color = colors.rand_hex()
local function get_next_color()
    local prev_color = next_color
    next_color = colors.rotate_hue(prev_color, 33)
    return prev_color
end

-- Returns (or generates) a button image based on the given params
---@param name string The name of this button
---@param is_focused boolean Is this button focused?
---@param is_on boolean Is this button on?
---@return any button_image
local function create_button_image(name, is_focused, event, is_on)
    local focus_state = is_focused and "focused" or "unfocused"
    local key_img

    -- If it is a toggle button, then the key has an extra param
    if is_on ~= nil then
        local toggle_state = is_on and "on" or "off"
        key_img = ("%s_%s_%s_%s"):format(name, toggle_state, focus_state, event)
    else
        key_img = ("%s_%s_%s"):format(name, focus_state, event)
    end

    -- If an image already exists, then we are done
    if _private[key_img] then
        return _private[key_img]
    end

    -- The color key just has _color at the end
    local key_color = key_img .. "_color"

    -- If the user hasn't provided a color, then we have to generate one
    if not _private[key_color] then
        local key_base_color = name .. "_color"

        -- Maybe the user has at least provided a base color? If not we just pick a pesudo-random color
        local base_color = _private[key_base_color] or get_next_color()
        _private[key_base_color] = base_color
        local button_color = base_color
        local H = colors.hex2hsv(base_color)

        -- Unfocused buttons are desaturated and darkened (except when they are being hovered over)
        if not is_focused and event ~= "hover" then
            button_color = colors.hsv2hex(H, 0, 50)
        end

        -- Then the color is lightened if the button is being hovered over, or darkened if it is being pressed, otherwise it is left as is
        button_color =
            (event == "hover") and colors.lighten(button_color, 25) or
                (event == "press") and colors.darken(button_color, 25) or
                button_color

        -- Save the generate color because why not lol
        _private[key_color] = button_color
    end

    local button_size = _private.button_size
    _private[key_img] = shapes.circle_filled(_private[key_color], button_size)
    return _private[key_img]
end

-- Creates a titlebar button widget
---@param c any The client to make a button widget for
---@param name string The name of this client
---@param button_callback function The callback to call when this button is pressed
---@param property any
---@return any widget The wibox widget created
local function create_titlebar_button(c, name, button_callback, property)
    local button_img = imagebox(nil, false)
    if _private.tooltips_enabled then
        local tooltip = awful.tooltip({
            timer_function = function()
                local prop = property and (c[property] and "_active" or "_inactive") or ""
                return _private.tooltip_messages[name .. prop]
            end,
            delay_show = 0.5,
            margins_leftright = 12,
            margins_topbottom = 6,
            timeout = 0.25,
            align = "bottom_right",
        })
        tooltip:add_to_object(button_img)
    end

    -- Update this window
    local is_on, is_focused
    local event = "normal"
    local function update()
        is_focused = c.active
        if property then
            is_on = c[property]
            button_img.image = create_button_image(name, is_focused, event, is_on)
        else
            button_img.image = create_button_image(name, is_focused, event)
        end
    end

    -- Update the button when the client gains/loses focus
    c:connect_signal("unfocus", update)
    c:connect_signal("focus", update)

    -- If the button is for a property that can be toggled, update it accordingly
    if property then
        c:connect_signal("property::" .. property, update)
    end

    -- Update the button on mouse hover/leave
    button_img:connect_signal("mouse::enter", function()
        event = "hover"
        update()
    end)
    button_img:connect_signal("mouse::leave", function()
        event = "normal"
        update()
    end)

    -- The button is updated on both click and release, but the call back is executed on release
    button_img.id = "button_image"
    button_img.buttons = awful.button({}, MB_LEFT, 
        function()
            event = "press"
            update()
        end,
        function()
            if button_callback then
                event = "normal"
                button_callback()
            else
                event = "hover"
            end
            update()
        end
    )
    update()

    -- Return a new widget.
    return wibox.widget({
        widget = wcontainer_place,
        {
            widget = wcontainer_margin,
            top = _private.button_margin_top or _private.button_margin_vertical or
                _private.button_margin,
            bottom = _private.button_margin_bottom or
                _private.button_margin_vertical or _private.button_margin,
            left = _private.button_margin_left or
                _private.button_margin_horizontal or _private.button_margin,
            right = _private.button_margin_right or
                _private.button_margin_horizontal or _private.button_margin,
            {
                button_img,
                widget = wcontainer_constraint,
                height = _private.button_size,
                width = _private.button_size,
                strategy = "exact",
            },
        },
    })
end

-- Get mouse bindings for a certain client's titlebar
---@param c any The client to get mouse bindings for
---@return table buttons
local function get_titlebar_mouse_bindings(c)
    -- Add functionality for double click to (un)maximize, and single click and hold to move
    local buttons = {
        -- move
        awful.button({}, _private.mb_move, function()
            c:activate{context = "titlebar", action = "mouse_move"}
        end),

        -- Autocolor when middle clicked.
        awful.button({}, MB_MIDDLE, function()
            c:emit_signal("pickcolor")
        end),

        -- reset colors
        awful.button({}, _private.mb_contextmenu, function()
            -- The right click menu for the window.
            awful.menu({
                items = {
                    {"close window", function()
                        c:kill()
                    end, beautiful.awesome_icon},
                    {"automatically choose window color", function()
                        c:emit_signal("autocolor")
                    end},
                    {"manually choose window color", function()
                        c:emit_signal("pickcolor")
                    end},
                    {"reset window color", function()
                        c:emit_signal("resetcolor")
                    end},
                    {"minimize", function()
                        c.minimized = true
                    end},
                    {"nevermind", function()

                    end},
                }
            }):show()
        end),
    }
    return buttons
end

-- Returns a titlebar widget for the given client
---@param c any The client to make a titlebar for
---@return any The titlebar that was created.
local function create_titlebar_title(c)
    -- Create a title widget.
    local client_color = c._cool_base_color
    local title_widget = wibox.widget({
        align = "center",
        ellipsize = "middle",
        opacity = c.active and 1 or TITLE_UNFOCUSED_OPACITY,
        valign = "center",
        widget = textbox,
    })

    -- Update the titlebar's name.
    local function update()
        local titlebar_name
        if string.len(c.name) > MAX_TITLE_LEN then
            titlebar_name = string.sub(c.name, 1, MAX_TITLE_LEN) .. "..."
        else
            titlebar_name = c.name
        end

        -- Set the text color
        local text_color = is_contrast_acceptable(TITLE_COLOR_LIGHT, client_color)
            and TITLE_COLOR_LIGHT or TITLE_COLOR_DARK

        -- Generate the markup
        title_widget.markup =("<span foreground='%s' font='%s'>%s</span>"):format(
                text_color, _private.titlebar_font, titlebar_name)
    end

    -- Connect changed signals
    c:connect_signal("property::name", update)
    c:connect_signal(
        "unfocus", function()
            title_widget.opacity = TITLE_UNFOCUSED_OPACITY
        end)
    c:connect_signal("focus", function() title_widget.opacity = 1 end)
    update()

    -- Return information for the titlebar that was created.
    local titlebar_font_height = get_font_height(_private.titlebar_font)
    local leftover_space = _private.titlebar_height - titlebar_font_height
    local margin_vertical = leftover_space > 1 and leftover_space / 2 or 0
    return {
        title_widget,
        widget = wcontainer_margin,
        top = margin_vertical,
        bottom = margin_vertical,
    }
end

-- Returns a titlebar item
---@param c any The client to get the titlebar item for
---@param name string The name of the titlebar item to retrieve.
---@return any item The  item that was retrieved from the titlebar.
local function get_titlebar_item(c, name)
    if name == "close" then
        return create_titlebar_button(c, name, function()
            c:kill()
        end)
    elseif name == "maximize" then
        return create_titlebar_button(c, name, function()
            c.maximized = not c.maximized
        end, "maximized")
    elseif name == "minimize" then
        return create_titlebar_button(c, name, function()
            c.minimized = true 
        end)
    elseif name == "ontop" then
        return create_titlebar_button(c, name, function()
            c.ontop = not c.ontop
        end, "ontop")
    elseif name == "floating" then
        return create_titlebar_button(c, name, function()
            c.floating = not c.floating
            if c.floating then
                c.maximized = false
            end
        end, "floating")
    elseif name == "sticky" then
        return create_titlebar_button(c, name, function()
            c.sticky = not c.sticky
            return c.sticky
        end, "sticky")
    elseif name == "title" then
        return create_titlebar_title(c)
    end
end

-- Creates titlebar items for a given group of item names
---@param c any The client to make titlebar items for.
---@param group string The group to make titlebar items for.
---@return any titlebar_group_items
local function create_titlebar_items(c, group)
    -- Do nothing if no group is provided.
    if not group then
        return nil
    end

    -- If the group already exists, return it.
    if type(group) == "string" then
        return get_titlebar_item(c, group)
    end

    -- Make grup items.
    local titlebar_group_items = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
    }

    -- Otherwise, add new items.
    local item
    for _, name in ipairs(group) do
        item = get_titlebar_item(c, name)
        if item then
            titlebar_group_items:add(item)
        end
    end

    return titlebar_group_items
end

-- Puts all the pieces together and decorates the given client
---@param c any The client to add window decorations to.
function _private.add_window_decorations(c)
    -- Get information to use for this client.
    local client_color = c._cool_base_color
    local stroke_width_inner = _private.stroke_width_inner or STROKE_WIDTH_INNER
    local stroke_width_outer = _private.stroke_width_outer or STROKE_WIDTH_OUTER
    local stroke_offset_outer = stroke_width_outer / 2
    local stroke_offset_inner = stroke_width_inner + stroke_offset_outer
    local edge_width = stroke_width_outer + stroke_width_inner
    local titlebar_height = _private.titlebar_height
    local titlebar_radius = _private.titlebar_radius

    -- Color computations
    local luminance = relative_luminance(client_color)
    local lighten_amount = rel_lighten(luminance)
    local darken_amount = rel_darken(luminance)
    local background_fill = color(client_color)

    -- Calculate inner color
    local stroke_color_inner = "#FFFFFF" .. INNER_TRANSPARENCY

    -- Calculate outer color
    local stroke_color_outer
    if relative_luminance(client_color) > 0.5 then
        stroke_color_outer = darken(client_color, darken_amount)
            .. OUTER_TRANSPARENCY
    else
        stroke_color_outer = lighten(client_color, lighten_amount)
            .. OUTER_TRANSPARENCY
    end

    -- The top left corner of the titlebar
    local corner_top_left_img = create_corner_top_left({
        background_source = background_fill,
        color = client_color,
        height = titlebar_height,
        radius = titlebar_radius,
        stroke_offset_inner = stroke_offset_inner,
        stroke_offset_outer = stroke_offset_outer,
        stroke_width_inner = stroke_width_inner,
        stroke_width_outer = stroke_width_outer,
        stroke_source_inner = color(stroke_color_inner),
        stroke_source_outer = color(stroke_color_outer),
    })
    local corner_top_right_img = shapes.flip(corner_top_left_img, "horizontal")
    local top_edge = create_edge_top_middle({
        background_source = background_fill,
        color = client_color,
        height = titlebar_height,
        stroke_color_inner = stroke_color_inner,
        stroke_color_outer = stroke_color_outer,
        stroke_offset_inner = stroke_offset_inner,
        stroke_offset_outer = stroke_offset_outer,
        stroke_width_inner = stroke_width_inner,
        stroke_width_outer = stroke_width_outer,
        width = _private.max_width,
    })

    -- Create the titlebar to arrange graphics.
    local titlebar = awful.titlebar(c, {
        size = titlebar_height, bg = "transparent"
    })
    titlebar.widget = {
        imagebox(corner_top_left_img, false),
        {
            {
                {
                    create_titlebar_items(c, _private.titlebar_items.left),
                    widget = wcontainer_margin,
                    left = _private.titlebar_margin_left,
                },
                {
                    create_titlebar_items(c, _private.titlebar_items.middle),
                    buttons = get_titlebar_mouse_bindings(c),
                    layout = wibox.layout.flex.horizontal,
                },
                {
                    create_titlebar_items(c, _private.titlebar_items.right),
                    widget = wcontainer_margin,
                    right = _private.titlebar_margin_right,
                },
                layout = wibox.layout.align.horizontal,
            },
            widget = wcontainer_background,
            bgimage = top_edge,
        },
        imagebox(corner_top_right_img, false),
        layout = wibox.layout.align.horizontal,
    }

    local left_edge = create_edge_left({
        client_color = client_color,
        height = _private.max_height,
        width = edge_width,
        stroke_width_inner = stroke_width_inner,
        stroke_offset_inner = stroke_offset_inner,
        stroke_width_outer = stroke_width_outer,
        stroke_offset_outer = stroke_offset_outer,
        stroke_color_inner = stroke_color_inner,
        stroke_color_outer = stroke_color_outer,
    })
    local right_edge = shapes.flip(left_edge, "horizontal")
    local left_side_border = awful.titlebar(c, {
        position = "left",
        size = edge_width,
        bg = client_color,
        widget = wcontainer_background,
    })
    left_side_border:setup({
        widget = wcontainer_background,
        bgimage = left_edge,
    })
    local right_side_border = awful.titlebar(c, {
        position = "right",
        size = edge_width,
        bg = client_color,
        widget = wcontainer_background,
    })
    right_side_border:setup({
        widget = wcontainer_background,
        bgimage = right_edge,
    })

    -- Make bottom left and right images.
    local corner_bottom_left_img = shapes.flip(create_corner_top_left({
        color = client_color,
        radius = BOTTOM_EDGE_HEIGHT,
        height = BOTTOM_EDGE_HEIGHT,
        background_source = background_fill,
        stroke_offset_inner = stroke_offset_inner,
        stroke_offset_outer = stroke_offset_outer,
        stroke_width_inner = stroke_width_inner,
        stroke_width_outer = stroke_width_outer,
        stroke_source_outer = color(stroke_color_outer),
        stroke_source_inner = color(stroke_color_inner),
    }), "vertical")
    local corner_bottom_right_img = shapes.flip(corner_bottom_left_img, "horizontal")

    -- Make the bottom edge.
    local bottom_edge = shapes.flip(create_edge_top_middle({
        color = client_color,
        height = BOTTOM_EDGE_HEIGHT,
        background_source = background_fill,
        stroke_offset_inner = stroke_offset_inner,
        stroke_offset_outer = stroke_offset_outer,
        stroke_width_inner = stroke_width_inner,
        stroke_width_outer = stroke_width_outer,
        stroke_color_inner = stroke_color_inner,
        stroke_color_outer = stroke_color_outer,
        width = _private.max_width,
    }), "vertical")
    local bottom = awful.titlebar(c, {
        size = BOTTOM_EDGE_HEIGHT,
        bg = "transparent",
        position = "bottom",
    })
    bottom.widget = wibox.widget({
        imagebox(corner_bottom_left_img, false),
        imagebox(bottom_edge, false),
        imagebox(corner_bottom_right_img, false),
        layout = wibox.layout.align.horizontal,
    })

    -- Don't use the titlebar when maximized.
    if _private.no_titlebar_maximized then
        c:connect_signal("property::maximized", function()
            if c.maximized then
                local curr_screen_workarea = client.focus.screen.workarea
                awful.titlebar.hide(c)
                c.shape = nil
                c:geometry{
                    x = curr_screen_workarea.x,
                    y = curr_screen_workarea.y,
                    width = curr_screen_workarea.width,
                    height = curr_screen_workarea.height,
                }
            else
                awful.titlebar.show(c)
                c.shape = shapes.rounded_rect({
                    tl = titlebar_radius,
                    tr = titlebar_radius,
                    bl = BOTTOM_EDGE_HEIGHT,
                    br = BOTTOM_EDGE_HEIGHT,
                })
            end
        end)
    end

    -- Clean up
    collectgarbage("collect")
end

-- Update the global screen dimensions.
local function update_max_screen_dims()
    local max_height, max_width = 0, 0
    for s in screen do
        max_height = math.max(max_height, s.geometry.height)
        max_width = math.max(max_width, s.geometry.width)
    end
    _private.max_height = max_height * 1.5
    _private.max_width = max_width * 1.5
end

-- Make sure the mouse button bindings are valid.
local function validate_mb_bindings()
    local action_mbs = {
        "mb_move",
        "mb_contextmenu",
    }
    local mb_specified = {false, false, false, false, false}
    local mb, mb_conflict_test
    for _, action_mb in ipairs(action_mbs) do
        mb = _private[action_mb]
        if mb then
            -- Make sure the mouse button is valid
            assert(mb >= 1 and mb <= 5, "Invalid mouse button specified!")
            mb_conflict_test = mb_specified[mb]
            if not mb_conflict_test then
                mb_specified[mb] = action_mb
            else
                error(("%s and %s can not be bound to the same mouse button"):format(
                    action_mb, mb_conflict_test))
            end
        end
    end
end

-- Initialize this module.
local function initialize(args)
    -- Update the screen dimensions.
    screen.connect_signal("list", update_max_screen_dims)
    update_max_screen_dims()

    -- Set up private parameters.
    local crush = require("gears.table").crush
    local table_args = {
        titlebar_items = true,
        context_menu_theme = true,
        tooltip_messages = true,
    }
    if args then
        for prop, value in pairs(args) do
            if table_args[prop] == true then
                crush(_private[prop], value)
            elseif prop == "titlebar_radius" then
                value = math.max(3, value)
                _private[prop] = value
            else
                _private[prop] = value
            end
        end
    end

    -- Make sure the mouse bindings are valid.
    validate_mb_bindings()

    -- Automatically recolor the client.
    client.connect_signal("autocolor", function(c)
        c._cool_base_color = auto_set_dominant_color(c)
        set_color_rule(c, c._cool_base_color)
        _private.add_window_decorations(c)
    end)

    -- Reset the titlebar color.
    client.connect_signal("resetcolor", function(c)
        c._cool_base_color = _private.titlebar_color
        set_color_rule(c, c._cool_base_color)
        _private.add_window_decorations(c)
    end)

    -- Pick a color manually.
    client.connect_signal("pickcolor", function(c)
        mousegrabber.run(function(m)
            if m.buttons[1] then
                c._cool_base_color = get_pixel_at(m.x, m.y)
                set_color_rule(c, c._cool_base_color)
                _private.add_window_decorations(c)
                return false
            end
            return true
        end, "crosshair")
    end)

    -- When titlebars are requested, add them.
    client.connect_signal("request::titlebars", function(c)
        c._cb_add_window_decorations = function()
            gtimer.weak_start_new(0.25, function()
                c:emit_signal("autocolor")
                c:disconnect_signal("request::activate", c._cb_add_window_decorations)
            end)
        end

        -- Check if a color rule already exists...
        local base_color = get_color_rule(c)
        if base_color then
            -- If so, use that color rule
            c._cool_base_color = base_color
            _private.add_window_decorations(c)
        else
            -- Otherwise use the default titlebar temporarily
            c._cool_base_color = _private.titlebar_color
            _private.add_window_decorations(c)
            c:connect_signal("request::activate", c._cb_add_window_decorations)
        end

        -- Shape the client
        c.shape = shapes.rounded_rect {
            tl = _private.titlebar_radius,
            tr = _private.titlebar_radius,
            bl = 4,
            br = 4,
        }
    end)
end

return {
    initialize = initialize,
}

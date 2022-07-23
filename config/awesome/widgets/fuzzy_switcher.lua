-- A finder shell

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local popup = require("widgets.popup")
local fzy = require("util.fzy")
local dpi = beautiful.xresources.apply_dpi

local PADDING = dpi(10)

-- make the finder widgee
local finder = awful.widget.prompt({
    fg = popup.fg,
    bg = popup.bg
})

-- make a popup and set it up
local finder_popup = popup(dpi(400), dpi(75))
finder_popup:setup({
    {
        {
            widget = wibox.widget.imagebox,
            resize = false
        },
        top = dpi(PADDING),
        left = dpi(PADDING),
        layout = wibox.container.margin
    },
    {
        layout = wibox.container.margin,
        left = dpi(PADDING),
        finder,
    },
    id = 'left',
    layout = wibox.layout.fixed.horizontal
})

-- Close the finder
local function close()
    finder_popup:close()
end

-- Only iterate over visible clients
local function visible(c)
    return c:isvisible()
end

-- Match a client by name
---@param name_query string The name of the client to match
---@return any client The client that was matched, if any.
local function match_client(name_query)
    local closest_match_score = 0
    local closest_match = nil
    for c in awful.client.iterate(visible) do
        -- Try matching both the name and class.
        -- Take whichever is bigger.
        local match_score = math.max(
            fzy.score(name_query, c.name, false),
            fzy.score(name_query, c.class, false)
        )
        if match_score > closest_match_score then
            closest_match = c
            closest_match_score = match_score
        end
    end
    return closest_match
end

-- Activate a client.
---@param c table The client to activate
local function activate(c)
    -- If there's no client, do nothing.
    if c == nil then
        return
    end

    -- Raise this client
    c:emit_signal("request::activate", "fuzzy_switcher", {raise = true})
    c:raise()
end

-- Open the fuzzy switcher
local function launch()
    local font_face = beautiful.font_face or "sans"
    local match

    -- show the prompt, center it and run it
    finder_popup:open()
    awful.prompt.run({
        font = font_face .. " 24",
        prompt = "focus: ",
        fg_cursor = beautiful.fg_focus,
        bg_cursor = beautiful.bg_focus,
        textbox = finder.widget,
        keypressed_callback = function(_, key, cmd)
            if key:len() == 1 then
                match = match_client(cmd .. key)
            else
                match = match_client(cmd)
            end
            activate(match)
        end,
        exe_callback = function()
            activate(match)
        end,
        done_callback = function()
            finder_popup:close()
        end
    })
end

return {
    launch = launch,
    close = close
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
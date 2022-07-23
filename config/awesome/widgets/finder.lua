-- A finder shell

local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local popup = require("widgets.popup")
local gfs = require("gears.filesystem")
local dpi = beautiful.xresources.apply_dpi

local PADDING = dpi(10)

-- make the finder widget
local finder = awful.widget.prompt({
    fg = popup.fg,
    bg = popup.bg
})

-- make a popup and set it up
local finder_popup = popup(dpi(750), dpi(75))
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

-- Open the finder
---@param prompt string The prompt to use
---@param history_dir string Where the history should be stored
---@param callback function The function to be called upon a completed search
local function launch(prompt, history_dir, callback)
    -- the history path
    local history_path = gfs.get_dir('cache') .. '/' .. history_dir
    local font_face = beautiful.font_face or "sans"

    -- show the prompt, center it and run it
    finder_popup:open()
    awful.prompt.run({
        font = font_face .. " 24",
        prompt = ("%s: "):format(prompt),
        fg_cursor = beautiful.fg_focus,
        bg_cursor = beautiful.bg_focus,
        textbox = finder.widget,
        history_path = history_path,
        exe_callback = function(...)
            local success, err = pcall(callback, ...)
            if not success then
                naughty.notify({
                    text = "Finder error: " .. err
                })
            end
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
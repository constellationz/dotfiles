-- Custom tag list.

local awful = require("awful")
local wibox = require("wibox")
local shortcuts = require("shortcuts")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local MARGINS  = beautiful.statusbar_margins or dpi(5)
local MAX_WIDTH = dpi(150)

-- Create a tag list on screen s
---@param s any The screen to make the tag list on
---@return any task_list
local function create_tag_list(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = shortcuts.tasklist_buttons,
		style = {
			shape = gears.shape.rectangle,
		},
		layout = {
			spacing = MARGINS,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				layout = wibox.layout.fixed.horizontal,
				{
					awful.widget.clienticon,
					margins = MARGINS,
					layout = wibox.container.margin,
				},
				{
					{
						{
							id = "text_role",
							widget = wibox.widget.textbox,
						},
						width = MAX_WIDTH,
						widget = wibox.container.constraint,
					},
					left = dpi(2),
					right = MARGINS,
					top = dpi(5),
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})
end

return {
	create = create_tag_list
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
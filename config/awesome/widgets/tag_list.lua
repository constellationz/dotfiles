-- Custom tag list module

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local shortcuts = require("shortcuts")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local TOP_MARGIN = dpi(8)
local SIDE_MARGIN = dpi(10)
local STATUSBAR_TAG_DOT = beautiful.statusbar_tag_dot or dpi(4)

-- Create a tag list.
---@param s any The screen to make the taglist on
---@return any tag_list
local function create_tag_list(s)
	return awful.widget.taglist {
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = shortcuts.taglist_buttons,
		style = {
			squares_sel = gears.surface.load_from_shape(
				STATUSBAR_TAG_DOT,
				STATUSBAR_TAG_DOT,
				gears.shape.transform(gears.shape.rectangle),
				beautiful.fg_focus
			),
			squares_sel_empty = gears.surface.load_from_shape(
				STATUSBAR_TAG_DOT,
				STATUSBAR_TAG_DOT,
				gears.shape.transform(gears.shape.rectangle),
				beautiful.fg_normal
			),
			squares_unsel = gears.surface.load_from_shape(
				STATUSBAR_TAG_DOT,
				STATUSBAR_TAG_DOT,
				gears.shape.transform(gears.shape.rectangle),
				beautiful.fg_normal
			),
		},
		widget_template = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					{
						{
							id = "text_role",
							widget = wibox.widget.textbox,
						},
						left = SIDE_MARGIN,
						right = SIDE_MARGIN,
						top = TOP_MARGIN,
						bottom = TOP_MARGIN,
						widget = wibox.container.margin,
					},
				},
				left = 0,
				right = 0,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
			shape = gears.shape.rectangle,
		},
	}
end

return {
	create = create_tag_list
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
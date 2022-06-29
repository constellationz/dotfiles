-- Custom clock widget

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widgets.clickable_container")

local FONT = beautiful.font or "sans 8"
local MILITARY_MODE = false
local CALENDAR_STARTS_ON_SUNDAY = true
local CALENDAR_SPACING = dpi(5) -- Spacing between days
local CALENDAR_MARGIN = dpi(5) -- Spacing around calendar
local TOOLTIP_MARGINS = dpi(5)
local CLOCK_MARGINS = beautiful.statusbar_margins or dpi(5)

-- Create a new clock on a screen s
---@param s any The screen to create a clock on
---@return any clock
local create_clock = function(s)
    -- Get the clock format.
    local clock_format = nil
    if not MILITARY_MODE then
        clock_format = "<span font=\"" .. FONT .. "\">%I:%M %p</span>"
    else
        clock_format = "<span font=\"" .. FONT .. "\">%H:%M</span>"
    end

    -- Make the clock
    s.clock = wibox.widget.textclock(clock_format, 1)
    s.clock_widget = wibox.widget({
        {
            s.clock,
            margins = CLOCK_MARGINS,
            widget = wibox.container.margin,
        },
        widget = clickable_container,
    })

    -- Make a tooltip when hovering over the clock.
    s.clock_tooltip = awful.tooltip({
        objects = { s.clock_widget },
        mode = "outside",
        delay_show = 1,
        preferred_positions = { "right", "left", "top", "bottom" },
        preferred_alignments = { "middle", "front", "back" },
        margin_leftright = TOOLTIP_MARGINS,
        margin_topbottom = TOOLTIP_MARGINS,
        timer_function = function()
            local day = os.date("%d")
            local month = os.date("%B")

            local first_digit = string.sub(day, 0, 1)
            local last_digit = string.sub(day, -1)

            if first_digit == "0" then
                day = last_digit
            end

            local ordinal = nil
            if last_digit == "1" and day ~= "11" then
                ordinal = "st"
            elseif last_digit == "2" and day ~= "12" then
                ordinal = "nd"
            elseif last_digit == "3" and day ~= "13" then
                ordinal = "rd"
            else
                ordinal = "th"
            end

            local date_str = "Today is the "
                .. "<b>"
                .. day
                .. ordinal
                .. " of "
                .. month
                .. "</b>.\n"
                .. "And it's "
                .. os.date("%A")

            return date_str
        end,
    })

    -- Hide the tooltip when you press the clock widget
    s.clock_widget:connect_signal("button::press", function(self, lx, ly, button)
        if s.clock_tooltip.visible and button == 1 then
            s.clock_tooltip.visible = false
        end
    end)

    -- Make a calendar widget
    s.month_calendar = awful.widget.calendar_popup.month({
        start_sunday = CALENDAR_STARTS_ON_SUNDAY,
        spacing = dpi(5),
        font = FONT,
        long_weekdays = true,
        margin = CALENDAR_MARGIN,
        screen = s,
        style_month = {
            border_width = 0,
            bg_color = beautiful.bg_normal,
            padding = CALENDAR_SPACING,
            shape = gears.shape.rectangle
        },
        style_header = {
            border_width = 0,
            bg_color = beautiful.transparent,
        },
        style_weekday = {
            border_width = 0,
            bg_color = beautiful.transparent,
        },
        style_normal = {
            border_width = 0,
            bg_color = beautiful.transparent,
        },
        style_focus = {
            border_width = 0,
            border_color = beautiful.fg_normal,
            bg_color = beautiful.bg_focus,
            shape = gears.shape.rectangle
        },
    })

    s.month_calendar:attach(s.clock_widget, "tr", {
        on_pressed = true,
        on_hover = false,
    })

    return s.clock_widget
end

return {
    create = create_clock
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
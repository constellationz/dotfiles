-- Configuration for the mouse and mouse sensitivity.

local awful = require("awful")

local sens = 0.4
local xinput_mouse_id = 18

local mouse = {
    sens = sens,
    lmb = 1,
    mmb = 2,
    rmb = 3,
}

-- Sets the X11 mouse sensitivity.
function mouse.export_sens()
    awful.spawn(string.format(
        "xinput set-prop %d \"Coordinate Transformation Matrix\" %.2f 0 0 0 %.2f 0 0 0 1",
        xinput_mouse_id,
        sens,
        sens
    ))
end

return mouse

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
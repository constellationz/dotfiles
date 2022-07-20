-- A better resize handler

local layout = require("layout")

-- Resize a client
---@param c any The client to resize.
local function resize_client(c)
    -- Make sure the client is not maximized
    -- Restore the size of the window from when the resize started.
    local geometry = c:geometry()
    layout.restore(c)
    c:geometry(geometry)

    -- Allow the mouse to move around, recalculating the window size.
    local start_pos = mouse.coords()
    mousegrabber.run(function(coords)
        local keep_resizing = mouse.is_right_mouse_button_pressed
            c:geometry {
                x = geometry.x,
                y = geometry.y,
                width = geometry.width + coords.x - start_pos.x,
                height = geometry.height + coords.y - start_pos.y,
            }
        return keep_resizing
    end, "bottom_right_corner")
end

return {
    resize_client = resize_client
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
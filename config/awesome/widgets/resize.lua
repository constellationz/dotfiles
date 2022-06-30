-- A better resize handler

local mouse = mouse
local mousegrabber = mousegrabber

-- Resize a client
---@param c any The client to resize.
local function resize_client(c)
    -- Snap the mouse to the corner of the window to start.
    local geometry = c:geometry()
    local start_pos = mouse.coords()

    -- Allow the mouse to move around, recalculating the window size.
    mousegrabber.run(function(coords)
        local keep_resizing = mouse.is_right_mouse_button_pressed
            c:geometry({
                x = geometry.x,
                y = geometry.y,
                width = geometry.width + coords.x - start_pos.x,
                height = geometry.height + coords.y - start_pos.y,
            })
        return keep_resizing
    end, "bottom_right_corner")
end

return {
    resize_client = resize_client
}

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
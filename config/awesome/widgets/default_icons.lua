-- Use a default icon for windows that don't have a theme icon.

local gears = require("gears")
local config_path = require("gears.filesystem").get_configuration_dir()
local default_icon = config_path .. "theme/generic_window.png"

client.connect_signal("manage", function(c)
    if c and c.valid and not c.icon then
        local s = gears.surface(default_icon)
        c.icon = s._native
        s:finish()
    end
end)

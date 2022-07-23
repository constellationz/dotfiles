-- User configuration for programs.

local awful = require("awful")

local startup = {
    "picom", -- Compositor
    "xset s off -dpms", -- Inhibit screen from turning off
    "blueman-applet", -- Bluetooth applet
    "powerkit", -- Battery icon
    "nm-applet", -- Network manager applet
    "mictray", -- Microphone widget
    "bash -c \"! pgrep -x \"volumeicon\" > /dev/null && volumeicon\"", -- Volume icon
}

local browser = "qutebrowser"
local terminal = "alacritty"
local editor = "nvim"
local audio = "pavucontrol"
local network = "nm-connection-editor"
local files = terminal .. " -t ranger -e ranger"
local shell = "fish"
local find_folder = terminal .. " -t ranger -e " .. shell .. " -c \"ranger $(fd --hidden --type directory | fzf)\""
local screenshot = "ksnip"
local blueman = "blueman-manager"
local editor_cmd = terminal .. " -e " .. editor

local programs = {
    shell = shell,
    startup = startup,
    blueman = blueman,
    browser = browser,
    terminal = terminal,
    editor = editor,
    network = network,
    editor_cmd = editor_cmd,
    files = files,
    find_folder = find_folder,
    audio = audio,
    screenshot = screenshot,
}

-- Open a link
---@param query string The link to open.
function programs.open_link(query)
    awful.spawn(programs.browser .. " " .. query)
end

return programs

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
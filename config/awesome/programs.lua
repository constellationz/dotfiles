-- User configuration for programs.

local startup = {
    "picom", -- Compositor
    "xset s off -dpms", -- Inhibit screen from turning off
    "blueman-applet", -- Bluetooth applet
    "powerkit", -- Battery icon
    "nm-applet", -- Network manager applet
    "mictray", -- Microphone widget
    "bash -c \"! pgrep -x \"volumeicon\" > /dev/null && volumeicon\"", -- Volume icon
}

local browser = "chromium"
local terminal = "alacritty"
local editor = "nvim"
local audio = "pavucontrol"
local network = "nm-connection-editor"
local files = terminal .. " -e ranger"
local screenshot = ""
local blueman = "blueman-manager"
local editor_cmd = terminal .. " -e " .. editor

local programs = {
    startup = startup,
    blueman = blueman,
    browser = browser,
    terminal = terminal,
    editor = editor,
    network = network,
    editor_cmd = editor_cmd,
    files = files,
    audio = audio,
    screenshot = screenshot,
}

return programs

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
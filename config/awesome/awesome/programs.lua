-- User configuration for programs.

local startup = { "picom" }
local browser = "firefox"
local terminal = "alacritty"
local editor = "nvim"
local audio = "pavucontrol"
local files = terminal .. " -e ranger"
local screenshot = ""
local editor_cmd = terminal .. " -e " .. editor

local programs = {
    startup = startup,
    browser = browser,
    terminal = terminal,
    editor = editor,
    editor_cmd = editor_cmd,
    files = files,
    audio = audio,
    screenshot = screenshot,
}

return programs

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
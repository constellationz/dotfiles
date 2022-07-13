-- My awesome theme

local gears = require("gears")
local naughty = require("naughty")
local dpi = require("beautiful.xresources").apply_dpi
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()
local theme_assets = require("beautiful.theme_assets")

-- Used for auto generating colors.
local colors = require("cool.colors")

-- TODO: Save theme to .gitignore file
local my_theme = {
    wallpaper = config_path .. "theme/starmap_north.jpg",
    use_wallpaper_colors = true,
    use_dark_text = false,
    fg_override = "#ebdbb2", -- Gruvbox foreground
    -- bg_override = "#282828", -- Gruvbox background
}

local theme = {}

-- Set the wallpaper internally.
theme.wallpaper = my_theme.wallpaper or themes_path .. "default/background.png" 

-- Use these to theme the statusbar.
theme.statusbar_height          = dpi(26)
theme.statusbar_margins         = dpi(5)
theme.statusbar_button_width    = dpi(34)
theme.statusbar_button_height   = dpi(34)
theme.statusbar_tag_dot         = dpi(4)

-- Some modules use font_face instead of font.
theme.font_face     = "sans"
theme.font          = theme.font_face .. " 8"

-- Space icons apart in the systray.
theme.systray_icon_spacing = dpi(5)
theme.systray_spacing = dpi(5)

-- Default background colors.
theme.bg_normal     = "#222222"
theme.bg_focus      = "#333333"
theme.bg_minimize   = "#444444"
theme.bg_urgent     = "#4444AA"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"

-- Default foreground colors (light)
theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

-- Default foreground colors (dark)
theme.fg_normal_dark   = "#444444"
theme.fg_focus_dark    = "#111111"
theme.fg_urgent_dark   = "#111111"
theme.fg_minimize_dark = "#111111"

-- Regenerate the awesome icon.
local function generate_awesome_icon()
    theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_normal)
end

-- Set the wallpaper.
---@param s any The screen to set the wallpaper of.
function theme.set_wallpaper(s)
    gears.wallpaper.prepare_context(s)
    gears.wallpaper.maximized(theme.wallpaper, s)
end

-- Use a certain foreground color
-- Generates other colors from the foreground color.
---@param fg color The color to use.
local function use_fg(fg)
    theme.fg_normal = fg
    theme.fg_focus = fg
    theme.fg_urgent = fg
    theme.fg_minimize = fg
end

-- Use a certain foreground color
-- Generates other colors from the foreground color.
---@param bg color The color to use.
local function use_bg(bg)
    local focus = colors.lighten(bg, 10)
    local minimize = colors.lighten(bg, 20)
    theme.bg_normal = bg
    theme.bg_systray = bg
    theme.bg_focus  = focus
    theme.bg_urgent = minimize
    theme.bg_minimize = minimize
end

-- Initialize colors from the wallpaper.
function theme.get_colors_from_wallpaper()
    -- Try reading the wallpaper.
    local wallpaper_surface
    if gears.filesystem.file_readable(theme.wallpaper) then
        wallpaper_surface = gears.surface.load_uncached_silently(theme.wallpaper, nil)
    else
        naughty.notify({
            text = "Could not read your wallpaper: " .. tostring(theme.wallpaper)
        })
    end

    -- If the wallpaper can be turned into a surface, load it.
    if wallpaper_surface and my_theme.use_wallpaper_colors then
        local width, _ = gears.surface.get_size(wallpaper_surface)
        local dominant_color = colors.get_dominant_color(wallpaper_surface, width)
        use_bg(dominant_color)
    end

    -- Invert foreground colors if needed.
    if wallpaper_surface and my_theme.use_dark_text and my_theme.use_wallpaper_colors then
        use_fg(theme.fg_normal_dark)
    end

    -- If overrides exist, use them
    if my_theme.bg_override then
        use_bg(my_theme.bg_override)
    end
    if my_theme.fg_override then
        use_fg(my_theme.fg_override)
    end

    generate_awesome_icon()
end

-- theme.border_normal = "#222222"
-- theme.border_focus  = "#535d6c"
theme.useless_gap   = dpi(4)
theme.border_width  = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- theme.notification_height = 40
-- theme.notification_width  = 200
theme.notification_border_width = dpi(0)
theme.notification_icon_size = dpi(32)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(128)

-- Define the image to loads
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
generate_awesome_icon()

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Arc"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

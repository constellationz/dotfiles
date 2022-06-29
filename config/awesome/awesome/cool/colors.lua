-- Provides utility functions for handling colors

---@alias color {[1]: number, [2]: number, [3]: number, [4]: number}

local floor = math.floor
local max = math.max
local min = math.min
local random = math.random
local parse_color = require("gears.color").parse_color
local gdk = require("lgi").require("Gdk", "3.0")
local pixbuf_get_from_surface = gdk.pixbuf_get_from_surface

-- Clamp a value
---@param value number The value to clamp
---@param min_value number The minimum value
---@param max_value number The max value
---@return number clamped_value
local function clamp(value, min_value, max_value)
	return max(min(value, max_value), min_value)
end

-- Converts the given hex color to normalized rgba
---@param hex string The color in hex format
---@return color color
local function hex2rgb(hex)
	return parse_color(hex)
end

-- Converts the given hex color to hsv
---@param hex string The color in hex format
---@return number hue, number saturation, number value
local function hex2hsv(hex)
	local r, g, b = hex2rgb(hex)
	local C_max = max(r, g, b)
	local C_min = min(r, g, b)
	local delta = C_max - C_min
	local H, S, V
	if delta == 0 then
		H = 0
	elseif C_max == r then
		H = 60 * (((g - b) / delta) % 6)
	elseif C_max == g then
		H = 60 * (((b - r) / delta) + 2)
	elseif C_max == b then
		H = 60 * (((r - g) / delta) + 4)
	end
	if C_max == 0 then
		S = 0
	else
		S = delta / C_max
	end
	V = C_max
	return H, S * 100, V * 100
end

-- Converts the given hsv color to hex
---@param H number The hue [0-360]
---@param S number The saturation [0-100]
---@param V number The value [0-100]
---@return string hex
local function hsv2hex(H, S, V)
	S = S / 100
	V = V / 100
	if H > 360 then H = 360 end
	if H < 0 then H = 0 end
	local C = V * S
	local X = C * (1 - math.abs(((H / 60) % 2) - 1))
	local m = V - C
	local r_, g_, b_ = 0, 0, 0
	if H >= 0 and H < 60 then
		r_, g_, b_ = C, X, 0
	elseif H >= 60 and H < 120 then
		r_, g_, b_ = X, C, 0
	elseif H >= 120 and H < 180 then
		r_, g_, b_ = 0, C, X
	elseif H >= 180 and H < 240 then
		r_, g_, b_ = 0, X, C
	elseif H >= 240 and H < 300 then
		r_, g_, b_ = X, 0, C
	elseif H >= 300 and H < 360 then
		r_, g_, b_ = C, 0, X
	end
	local r, g, b = (r_ + m) * 255, (g_ + m) * 255, (b_ + m) * 255
	return ("#%02x%02x%02x"):format(floor(r), floor(g), floor(b))
end

-- Calculates the relative luminance of the given color
---@param color color
---@return number relative_luminance
local function relative_luminance(color)
	local r, g, b = hex2rgb(color)
	local function from_sRGB(u)
		-- return u <= 0.0031308 and 25 * u / 323 or pow(((200 * u + 11) / 211), 12 / 5)
		return u <= 0.0031308 and 25 * u / 323 or ((200 * u + 11) / 211) ^ (12 / 5)
	end
	return 0.2126 * from_sRGB(r) + 0.7152 * from_sRGB(g) + 0.0722 * from_sRGB(b)
end

-- Calculates the contrast ratio between the two given colors
---@param fg color
---@param bg color
---@return number contrast_ratio
local function contrast_ratio(fg, bg)
	return (relative_luminance(fg) + 0.05) / (relative_luminance(bg) + 0.05)
end

-- Returns true if the contrast between the two given colors is suitable
---@param fg color
---@param bg color
---@return boolean is_acceptable
local function is_contrast_acceptable(fg, bg)
	return contrast_ratio(fg, bg) >= 7
end

-- Returns a bright-ish, saturated-ish, color of random hue
---@param lb_angle number The lower bound of the hue
---@param ub_angle number The upper bound of the hue
---@return string random_hex
local function rand_hex(lb_angle, ub_angle)
	return hsv2hex(random(lb_angle or 0, ub_angle or 360), 70, 90)
end

-- Rotates the hue of the given hex color by the specified angle (in degrees)
---@param hex string The hex color
---@param angle number The angle to rotate the color by (hue shift)
---@return string new_hex
local function rotate_hue(hex, angle)
	local H, S, V = hex2hsv(hex)
	angle = clamp(angle or 0, 0, 360)
	H = (H + angle) % 360
	return hsv2hex(H, S, V)
end

-- Lightens a given hex color by the specified amount
---@param hex string The hex color to lighten
---@param amount number The amount to lighten by [0-100]
---@return string hex
local function lighten(hex, amount)
	local r, g, b = hex2rgb(hex)
	r = 255 * r
	g = 255 * g
	b = 255 * b
	r = r + floor(2.55 * amount)
	g = g + floor(2.55 * amount)
	b = b + floor(2.55 * amount)
	r = r > 255 and 255 or r
	g = g > 255 and 255 or g
	b = b > 255 and 255 or b
	return ("#%02x%02x%02x"):format(r, g, b)
end

-- Darkens a given hex color by the specified amount
---@param hex string The hex color to darken
---@param amount number The amount to darken by [0-100]
---@return string hex
local function darken(hex, amount)
	local r, g, b
	r, g, b = hex2rgb(hex)
	r = 255 * r
	g = 255 * g
	b = 255 * b
	r = max(0, r - floor(r * (amount / 100)))
	g = max(0, g - floor(g * (amount / 100)))
	b = max(0, b - floor(b * (amount / 100)))
	return ("#%02x%02x%02x"):format(r, g, b)
end

-- Determines the dominant color of the client's top region
---@param surface any The surface to get the dominant color of
---@param width number The width of the surface in pixels
local function get_dominant_color(surface, width)
    local tally = {}
    local color, pb, bytes

	-- Sample pixels from the top row
    local x_offset = 2
    local y_offset = 2
    local x_lim = floor(width / 2)
    for x_pos = 0, x_lim, 2 do
        for y_pos = 0, 8, 1 do
            pb = pixbuf_get_from_surface(surface, x_offset + x_pos, y_offset + y_pos, 1, 1)
            bytes = pb:get_pixels()
            color = "#" .. bytes:gsub(".", function(c)
				return ("%02x"):format(c:byte())
			end)
            if not tally[color] then
                tally[color] = 1
            else
                tally[color] = tally[color] + 1
            end
        end
    end

	-- Count the pixels and get the most common color
    local mode
    local mode_c = 0
    for kolor, kount in pairs(tally) do
        if kount > mode_c then
            mode_c = kount
            mode = kolor
        end
    end
    color = mode

    return color
end

return {
	clamp = clamp,
	hex2rgb = hex2rgb,
	hex2hsv = hex2hsv,
	hsv2hex = hsv2hex,
	relative_luminance = relative_luminance,
	contrast_ratio = contrast_ratio,
	get_dominant_color = get_dominant_color,
	is_contrast_acceptable = is_contrast_acceptable,
	rand_hex = rand_hex,
	rotate_hue = rotate_hue,
	lighten = lighten,
	darken = darken,
}

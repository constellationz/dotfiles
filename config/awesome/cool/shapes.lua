-- Provides utility functions for handling cairo shapes and geometry

---@alias font {font: string, italic: boolean, bold: boolean, kerning: boolean}

local FALLBACK_FONT = "sans"

local lgi = require("lgi")
local colors = require("cool.colors")
local rad = math.rad
local cairo = lgi.cairo
local hex2rgb = colors.hex2rgb

-- Returns a shape function for a rounded rectangle with independently configurable corner radii
---@param args {tl: number, bl: number, br: number, tr: number} The radii of each corner.
local function rounded_rect(args)
	local r1 = args.tl or 0
	local r2 = args.bl or 0
	local r3 = args.br or 0
	local r4 = args.tr or 0
	return function(cr, width, height)
		cr:new_sub_path()
		cr:arc(width - r1, r1, r1, rad(-90), rad(0))
		cr:arc(width - r2, height - r2, r2, rad(0), rad(90))
		cr:arc(r3, height - r3, r3, rad(90), rad(180))
		cr:arc(r4, r4, r4, rad(180), rad(270))
		cr:close_path()
	end
end

-- Returns a cairo surface for a circle of the specified size filled with the specified hex color.
---@param hex string The hex color of this circle.
---@param size number The size of this circle in pixels
local function circle_filled(hex, size)
	hex = hex or "#fefefa"
	local surface = cairo.ImageSurface.create("ARGB32", size, size)
	local cr = cairo.Context.create(surface)
	cr:arc(size / 2, size / 2, size / 2, rad(0), rad(360))
	cr:set_source_rgba(hex2rgb(hex))
	cr.antialias = cairo.Antialias.BEST
	cr:fill()
	-- cr:arc(
	--     size / 2, size / 2, size / 2 - 0.5, rad(135), rad(270))
	-- cr:set_source_rgba(hex2rgb(darken(color, 25)))
	-- cr.line_width = 1
	-- cr:stroke()

	return surface
end

-- Returns a vertical gradient patterm going from hex_1 -> hex_2
---@param hex_1 string The first hex color
---@param hex_2 string The second hex color
---@param height number The height of this gradient
---@param offset_1 number The first color stop of this gradient
---@param offset_2 number The second color stop of this gradient
---@return table fill_pattern The fill pattern to use for this gradient.
local function gradient_vertical(hex_1, hex_2, height, offset_1, offset_2)
	local fill_pattern = cairo.Pattern.create_linear(0, 0, 0, height)
	fill_pattern:add_color_stop_rgba(offset_1 or 0, hex2rgb(hex_1))
	fill_pattern:add_color_stop_rgba(offset_2 or 1, hex2rgb(hex_2))
	return fill_pattern
end

-- Return a cairo rgba surface.
---@param hex string The hex color to make the pattern
---@return table pattern The pattern to use for this color.
local function color(hex)
	return cairo.Pattern.create_rgba(hex2rgb(hex))
end

-- Flips the given surface around the specified axis
---@param surface table A cairo surface
---@param axis "horizontal" | "vertical" | "both" The axis to flip around
---@return table flipped The flipped surface
local function flip(surface, axis)
	local width = surface:get_width()
	local height = surface:get_height()

	-- Create a surface
	local flipped  = cairo.ImageSurface.create("ARGB32", width, height)
	local cr = cairo.Context.create(flipped)
	local source_pattern = cairo.Pattern.create_for_surface(surface)

	-- Flip the surface
	if axis == "horizontal" then
		source_pattern.matrix = cairo.Matrix({
			xx = -1,
			yy = 1,
			x0 = width
		})
	elseif axis == "vertical" then
		source_pattern.matrix = cairo.Matrix({
			xx = 1,
			yy = -1,
			y0 = height
		})
	elseif axis == "both" then
		source_pattern.matrix = cairo.Matrix({
			xx = -1,
			yy = -1,
			x0 = width,
			y0 = height,
		})
	end

	-- Paint the surface with a new source pattern.
	cr.source = source_pattern
	cr:rectangle(0, 0, width, height)
	cr:paint()

	return flipped
end

-- Draws the left corner of the titlebar
---@param args {}
---@return table surface The surface that was drawn
local function create_corner_top_left(args)
	local radius = args.radius
	local height = args.height
	local surface = cairo.ImageSurface.create("ARGB32", radius, height)
	local cr = cairo.Context.create(surface)

	-- Create the corner shape and fill it
	cr:move_to(0, height)
	cr:line_to(0, radius)
	cr:arc(radius, radius, radius, rad(180), rad(270))
	cr:line_to(radius, height)
	cr:close_path()
	cr.source = args.background_source
	cr.antialias = cairo.Antialias.BEST
	cr:fill()
	
	-- Next add the subtle 3D look
	---@param nargs {radius: number, offset_x: number, offset_y: number, source: table, width: number}
	local function add_stroke(nargs)
		local arc_radius = nargs.radius
		local offset = nargs.offset
		cr:new_sub_path()
		cr:move_to(offset, height)
		cr:line_to(offset, arc_radius + offset)
		cr:arc(arc_radius + offset, arc_radius + offset, arc_radius, rad(180), rad(270))
		cr.source = nargs.source
		cr.line_width = nargs.width
		cr.antialias = cairo.Antialias.BEST
		cr:stroke()
	end

	-- stroke
	add_stroke({
		offset = args.stroke_offset,
		radius = radius,
		source = args.stroke_source,
		width = args.stroke_width,
	})

	return surface
end

-- Draws the middle of the titlebar
---@param args {height: number, width: number, background_source: table}
---@return table surface
local function create_edge_top_middle(args)
	local height = args.height
	local width = args.width
	local surface = cairo.ImageSurface.create("ARGB32", width, height)
	local cr = cairo.Context.create(surface)

	-- Create the background shape and fill it with a gradient
	cr:rectangle(0, 0, width, height)
	cr.source = args.background_source
	cr:fill()

	-- Add a stroke.
	local function add_stroke(stroke_width, stroke_offset, stroke_color)
		cr:new_sub_path()
		cr:move_to(0, stroke_offset)
		cr:line_to(width, stroke_offset)
		cr.line_width = stroke_width
		cr.antialias = cairo.Antialias.BEST
		cr:set_source_rgba(hex2rgb(stroke_color))
		cr:stroke()
	end

	-- stroke
	add_stroke(args.stroke_width, args.stroke_offset, args.stroke_color)

	return surface
end

---Create a left edge.
---@param args {height: number, width: number, client_color: string}
local function create_edge_left(args)
	local height = args.height
	local width = args.width

	-- Create a cairo context
	local surface = cairo.ImageSurface.create("ARGB32", width, height)
	local cr = cairo.Context.create(surface)
	cr:rectangle(0, 0, width, args.height)
	cr:set_source_rgba(hex2rgb(args.client_color))
	cr:fill()

	-- Add a stroke.
	local function add_stroke(stroke_width, stroke_offset, stroke_color)
		cr:new_sub_path()
		cr:move_to(stroke_offset, 0)
		cr:line_to(stroke_offset, height)
		cr.line_width = stroke_width
		cr.antialias = cairo.Antialias.BEST
		cr:set_source_rgba(hex2rgb(stroke_color))
		cr:stroke()
	end

	-- stroke
	add_stroke(args.stroke_width, args.stroke_offset, args.stroke_color)

	return surface
end

-- Set the font of a cairo context
---@param cr table The cairo context
---@param font font Information about this font
local function set_font(cr, font)
	cr:set_font_size(font.size)
	cr:select_font_face(font.font or FALLBACK_FONT, font.italic and 1 or 0, font.bold and 1 or 0)
end

-- Make a new surface representing a text label.
---@param args {font: font, text: string, color: string}
---@return table surface The cairo surface that was created
local function text_label(args)
	-- Create a surface for this font.
	local surface = cairo.ImageSurface.create("ARGB32", 1, 1)
	local cr = cairo.Context.create(surface)
	set_font(cr, args.font)
	local text = args.text
	local kern = args.font.kerning or 0
	local ext = cr:text_extents(text)
	surface = cairo.ImageSurface.create("ARGB32", ext.width + string.len(text) * kern, ext.height)
	cr = cairo.Context.create(surface)
	set_font(cr, args.font)
	cr:move_to(0, ext.height)
	cr:set_source_rgba(hex2rgb(args.color))
	local _ = text:gsub(".", function(c)
		cr:show_text(c)
		cr:rel_move_to(kern, 0)
	end)
	return surface
end

return {
	rounded_rect = rounded_rect,
	circle_filled = circle_filled,
	gradient_vertical = gradient_vertical,
	color = color,
	flip = flip,
	create_corner_top_left = create_corner_top_left,
	create_edge_top_middle = create_edge_top_middle,
	create_edge_left = create_edge_left,
	text_label = text_label,
}

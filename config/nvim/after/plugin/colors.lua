-- Get default color
-- Can program to change based on environment
function GetDefaultColor()
	return "breezy"
	-- return "gruvbox-material"
end

-- Pick a colorscheme
-- Sometimes a color scheme will not be installed
function Color(color)
	pcall(vim.cmd, "colorscheme " .. color)
end

-- Set customization for gruvbox
do
	vim.g.gruvbox_material_sign_column_background = "grey"
	vim.g.gruvbox_material_foreground = "original"
	vim.g.gruvbox_material_disable_terminal_colors = true
	vim.g.gruvbox_material_disable_italic_comment = true
end

local ok, LoadColor = pcall(require, "customcolor")
if ok then
	LoadColor()
else
	Color(GetDefaultColor())
end

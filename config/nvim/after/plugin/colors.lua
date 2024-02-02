-- Get default color
-- Can program to change based on environment
function GetDefaultColor()
	return "gruvbox-material"
end

-- Pick a colorscheme
-- Sometimes a color scheme will not be installed
function Color(color)
	pcall(vim.cmd, "colorscheme " .. color)
end

-- Set variables for gruvbox
do
	vim.g.gruvbox_material_foreground = "classic"
end

local ok, LoadColor = pcall(require, "customcolor")
if ok then
	LoadColor()
else
	Color(GetDefaultColor())
end

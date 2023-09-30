-- Get default color
-- Can program to change based on environment
function GetDefaultColor()
	return "gruvbox"
end

-- Pick a colorscheme
-- Sometimes a color scheme will not be installed
function Color(color)
	pcall(vim.cmd, "colorscheme " .. color)
end

-- Nord quick command
vim.api.nvim_command('command!-bar Gruvbox lua Color("gruvbox-material")')

local ok, LoadColor = pcall(require, 'customcolor')
if ok then
	LoadColor()
else
	Color(GetDefaultColor())
end

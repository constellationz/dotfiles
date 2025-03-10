-- Use tabs of two
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Use smart indent
vim.o.smartindent = true
vim.o.wrap = true

-- Searches are case insensitive until uppercase is used
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep undo information in its own directory
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Highlight as we search
vim.o.incsearch = true

-- List certain whitespace characters
vim.o.listchars = "tab:>\\ ,trail:-,nbsp:+"

-- Use terminal colors
vim.o.termguicolors = false

-- Remove status line
vim.o.laststatus = 0

-- Use low update time
vim.o.updatetime = 50

-- Messages from netrw use echoerr
vim.g.netrw_use_errorwindow = 0

-- Don't allow column to use signs
vim.o.signcolumn = 'yes'

-- Use system clipboard
vim.o.clipboard = 'unnamedplus'

-- Neoformat
vim.g.neoformat_try_node_exe = 1

-- Neovide settings
if vim.g.neovide then
  vim.o.guifont = "Hack:h10"
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_refresh_rate = 240
end

-- Use numbers
vim.opt.nu = true

-- Use tabs of two
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Use smart indent
vim.opt.smartindent = true
vim.opt.wrap = true

-- Keep undo information in its own directory
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Highlight as we search
vim.opt.incsearch = true

-- Use terminal colors 
vim.opt.termguicolors = true

-- Use low update time
vim.opt.updatetime = 50

-- Set map leader
vim.g.mapleader = " "

-- Messages from netrw use echoerr
vim.g.netrw_use_errorwindow = 0

-- Don't allow column to use signs
vim.opt.signcolumn = 'yes'

-- Use system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Neoformat
vim.g.neoformat_try_node_exe = 1

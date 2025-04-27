-- Leader shortcuts
do
	-- Set map leader
	vim.g.mapleader = " "

	-- Paste/delete and put underlying text in void register
	vim.keymap.set("x", "<leader>p", '"_dP')
	vim.keymap.set("n", "<leader>d", '"_d')
	vim.keymap.set("v", "<leader>d", '"_d')
end

-- Navigation
do
	-- Copy the current buffer
	vim.keymap.set("n", "<C-c>", "<cmd>%y<CR>")

	-- Save current buffer
	vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

	-- Unbind capital q
	vim.keymap.set("n", "Q", "<cmd>close<CR>")

	-- Open new tab
	vim.keymap.set("n", "<C-t>", "<cmd>tabedit<CR>")

	-- Switch buffers 
	vim.keymap.set("n", "<C-n>", "<cmd>bnext<CR>")
	vim.keymap.set("n", "<C-p>", "<cmd>bprev<CR>")

	-- Format with Neoformat (plugin)
	vim.keymap.set("n", "<C-f>", "<cmd>Neoformat<CR>")

	-- Switch tabs
	vim.keymap.set("n", "<C-Tab>", "<cmd>tabnext<CR>")
	vim.keymap.set("n", "<C-S-Tab>", "<cmd>tabprev<CR>")

	-- Explorer
	vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")

	-- Show version control (plugin)
	vim.keymap.set("n", "<leader>v", "<cmd>Git<CR>")

	-- Live grep (plugin)
	vim.keymap.set("n", "<leader>g", "<cmd>Telescope live_grep<CR>")

	-- Workspace symbols (plugin)
	vim.keymap.set("n", "<leader>m", "<cmd>Telescope lsp_workspace_symbols<CR>")

	-- Toggle undo tree (plugin)
	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

	-- Open a buffer (plugin)
	vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")

	-- Find a file (plugin)
	vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>")

	-- Toggle numbers and whitespace rendering
	vim.keymap.set("n", "<leader>n", function()
		local shownumbers = not vim.o.nu
		vim.o.nu = shownumbers
		vim.o.list = shownumbers
	end)

	-- Toggle wrapping
	vim.keymap.set("n", "<C-a>", function()
		vim.o.wrap = not vim.o.wrap
	end)

	-- Quickfix navigation
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>")
end

-- Settings
do
	-- Use tabs of four
	vim.o.tabstop = 4
	vim.o.softtabstop = 4
	vim.o.shiftwidth = 4
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

	-- Use system clipboard
	vim.o.clipboard = 'unnamedplus'

	-- Neoformat
	vim.g.neoformat_try_node_exe = 1
end

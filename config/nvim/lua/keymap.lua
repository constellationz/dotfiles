-- Set map leader
vim.g.mapleader = " "

-- Editing
do
	-- "Cut all" matching words
	vim.keymap.set("n", "ca", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

	-- Paste/delete and put underlying text in void register
	vim.keymap.set("x", "<leader>p", '"_dP')
	vim.keymap.set("n", "<leader>d", '"_d')
	vim.keymap.set("v", "<leader>d", '"_d')
end

-- Navigation
do
	-- Unbind capital q
	vim.keymap.set("n", "Q", "<nop>")

	-- Copy the current buffer
	vim.keymap.set("n", "<C-c>", "<cmd>%y<CR>")

	-- Save current buffer
	vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

	-- Close/quit view
	vim.keymap.set("n", "<C-q>", "<cmd>close<CR>")

	-- Next buffer, previous buffer
	vim.keymap.set("n", "<C-n>", "<cmd>bnext<CR>")
	vim.keymap.set("n", "<C-p>", "<cmd>bprev<CR>")

	-- New tab with current buffer
	vim.keymap.set("n", "<C-t>", "<cmd>tabedit %<CR>")

	-- Next tab, previous tab
	vim.keymap.set("n", "<C-Tab>", "<cmd>tabnext<CR>")
	vim.keymap.set("n", "<C-S-Tab>", "<cmd>tabprev<CR>")

	-- Show git status (plugin)
	vim.keymap.set("n", "<C-g>", "<cmd>Git<CR>")

	-- Format with Neoformat (plugin)
	vim.keymap.set("n", "<C-f>", "<cmd>Neoformat<CR>")

	-- Explorer
	vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")

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

-- Set map leader
vim.g.mapleader = " "

-- Editing
do
	-- Replace current word with something
	vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

	-- Paste/delete and put underlying text in void register
	vim.keymap.set("x", "<leader>p", '"_dP')
	vim.keymap.set("n", "<leader>d", '"_d')
	vim.keymap.set("v", "<leader>d", '"_d')
end

-- Navigation
do
	-- Unbind capital q
	vim.keymap.set("n", "Q", "<nop>")

	-- Close current buffer
	vim.keymap.set("n", "<C-c>", "<cmd>bdelete<CR>")

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

	-- Format with Neoformat (plugin)
	vim.keymap.set("n", "<C-f>", "<cmd>Neoformat<CR>")

	-- Find with grep (plugin)
	vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<CR>")

	-- Explorer
	vim.keymap.set("n", "<leader>e", "<cmd>Ex<CR>")

	-- Show git status (plugin)
	vim.keymap.set("n", "<leader>g", "<cmd>Git<CR>")

	-- Toggle undo tree (plugin)
	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

	-- Open a buffer (plugin)
	vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")

	-- Find a file (plugin)
	vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>")

	-- Toggle numbers
	vim.keymap.set("n", "<leader>n", function()
		vim.o.nu = not vim.o.nu
	end)

	-- Quickfix navigation
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>")
end

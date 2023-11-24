-- Set map leader
vim.g.mapleader = " "

-- Editing
do
	-- Bring next line to end of line without moving cursor
	vim.keymap.set("n", "J", "mzJ`z")

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

	-- Save current buffer
	vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

	-- Close view
	vim.keymap.set("n", "<C-c>", "<cmd>close<CR>")

	-- Explorer
	vim.keymap.set("n", "<C-e>", "<cmd>Ex<CR>")

  -- List open buffers
	vim.keymap.set("n", "<C-b>", ":buffers<CR>:buffer ")

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

	-- Get git status with fugitive (plugin)
	vim.keymap.set("n", "<leader>g", "<cmd>Git<CR>")

	-- Toggle undo tree (plugin)
	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

	-- Quickfix navigation
	vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>")
	vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>")
	vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>")
	vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>")
end

-- Open explorer
vim.keymap.set("n", "<leader>ee", "<cmd>Ex<CR>")

-- Bring next line to end of line without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Paste/delete and put underlying text in void register
vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- Unbind capital q
vim.keymap.set("n", "Q", "<nop>")

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>")

-- Quick buffer navigation
vim.keymap.set("n", "<C-n>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<C-w>", "<cmd>bdelete<CR>")

-- Replace current word with something
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Undo tree toggle (plugin)
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

-- Neoformat (plugin)
vim.keymap.set("n", "<C-f>", "<cmd>Neoformat<CR>")

-- Get git status with fugitive (plugin)
vim.keymap.set("n", "<leader>g", "<cmd>Git<CR>")

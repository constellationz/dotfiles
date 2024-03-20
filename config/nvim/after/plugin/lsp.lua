-- LSP configuration
-- Note that LSP might not be installed in all configurations
-- Don't execute configuration if lsp is not installed
local lsp
local cmp
local ok = pcall(function()
	lsp = require("lsp-zero")
	cmp = require("cmp")
end)
if not ok then
	return
end

-- Set up lsp
do
	-- Use minimal defaults
	lsp.preset("minimal")

	-- Make sure certain language servers are installed
	lsp.ensure_installed({})

	-- For every buffer, override some shortcuts with language server shortcuts
	lsp.on_attach(function(_, bufnr)
		local opts = {
			buffer = bufnr,
			remap = false,
		}
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gl", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "gh", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, opts)
	end)

	-- Configure lsp for neovim
	lsp.nvim_workspace()

	-- No sign icons
	lsp.set_preferences({
		sign_icons = {},
	})

	-- Finish setup
	lsp.setup()
end

-- Set up cmp
do
	local cmp_select = { behavior = cmp.SelectBehavior.Select }
	cmp.setup({
		sources = {
			{ name = "nvim_lsp" },
		},
		mapping = {
			["<C-Up>"] = cmp.mapping.select_prev_item(cmp_select),
			["<C-Down>"] = cmp.mapping.select_next_item(cmp_select),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete(),
		},
		preselect = "none",
		completion = {
			completeopt = "menu,menuone,noinsert,noselect",
		},
	})
end

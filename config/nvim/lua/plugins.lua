-- Packer might not always be installed
-- Do nothing if packer isn't installed
local packer
pcall(function()
	vim.cmd("packadd packer.nvim")
	packer = require("packer")
end)
if packer == nil then
	return
end

-- Use :PackerSync to sync packages
return packer.startup(function(use)
	-- Packer
	use("wbthomason/packer.nvim")

	-- Gruvbox colorscheme
	use("morhetz/gruvbox")

	-- Prettier
	use("sbdchd/neoformat")

	-- Undo tree
	use("mbbill/undotree")

	-- Git integration
	use("tpope/vim-fugitive")

	-- Argument wrapping
	use("AndrewRadev/splitjoin.vim")

	-- Comments
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- Guess indentation
	use({
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	})

	-- LSP integration
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
end)

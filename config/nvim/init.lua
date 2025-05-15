-- Shortcuts
do
    -- Space as leader
    vim.g.mapleader = " "
    vim.keymap.set("n", vim.g.mapleader, "<Nop>", {
        silent = true,
        remap = false,
    })

    -- <C-s> to save
    vim.keymap.set("n", "<C-c>", "<cmd>%y<CR>")
    vim.keymap.set("i", "<C-c>", "<cmd>%y<CR>")

    -- <C-y> to copy entire buffer
    vim.keymap.set("n", "<C-y>", "<cmd>w<CR>")
    vim.keymap.set("i", "<C-y>", "<cmd>w<CR>")

    -- View floating diagnostic
    vim.keymap.set("n", "<leader>k", function()
        vim.diagnostic.open_float()
    end)
end

-- Settings
do
    -- Use system clipboard
    vim.o.clipboard = 'unnamedplus'

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
    vim.o.undofile = true
    vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

    -- Use incremental highlighting on search
    vim.o.incsearch = true

    -- List certain whitespace characters
    vim.o.listchars = "tab:>  ,trail:-,nbsp:+"

    -- Remove status line
    vim.o.laststatus = 0

    -- Use low update time
    vim.o.updatetime = 50

    -- Messages from netrw use echoerr
    vim.g.netrw_use_errorwindow = 0
end

-- LSP server configuration
do
    -- Enable configs
    for name, config in pairs {
        luals = {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        },
        rust_analyzer = {
            cmd = { 'rust-analyzer' },
            filetypes = { 'rust' },
            single_file_support = true,
            root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
        }
    } do
        vim.lsp.config[name] = config
        vim.lsp.enable(name)
    end
end

-- LSP custom shortcuts
do
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

            -- Formatting
            if client:supports_method('textDocument/formatting') then
                local function format()
                    vim.lsp.buf.format {
                        bufnr = args.buf,
                        id = client.id,
                        timeout_ms = 1000
                    }
                    print('formatted buffer', args.buf)
                end
                vim.keymap.set('n', '<C-f>', format)
                vim.keymap.set('i', '<C-f>', format)
            end
        end,
    })
end

-- Themes
do
    require('gruvbox').setup {
        bold = false,
        italic = {
            strings = false,
            emphasis = false,
            comments = false,
            operators = false,
            folds = false
        },
    }
    require('onedark').setup {
        code_style = {
            comments = 'none',
            keywords = 'none',
            functions = 'none',
            strings = 'none',
            variables = 'none',
        },
    }

    -- Set local theme
    pcall(function()
        local theme = require('theme')
        if theme then
            vim.cmd('colors ' .. theme)
        end
    end)
end

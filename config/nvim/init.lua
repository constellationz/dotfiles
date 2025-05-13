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

    -- Switch tabs
    vim.keymap.set("n", "<leader>\t", "<cmd>tabnext<CR>")
    vim.keymap.set("n", "<leader>`", "<cmd>tabprev<CR>")

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

    -- Toggle numbers
    vim.keymap.set("n", "<leader>n", function()
        local show_numbers = not vim.o.nu
        if show_numbers then
            print('showing numbers')
        else
            print('hiding numbers')
        end
        vim.o.nu = show_numbers
    end)

    -- Toggle whitespace rendering
    vim.keymap.set("n", "<leader>w", function()
        local show = not vim.o.list
        vim.o.list = show
        if show then
            print('showing whitespace')
        else
            print('hiding whitespace')
        end
    end)

    -- Toggle wrapping
    vim.keymap.set("n", "<C-a>", function()
        local wrap = not vim.o.wrap
        if wrap then
            print('wrapping text')
        else
            print('not wrapping text')
        end
        vim.o.wrap = wrap
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
    -- vim.o.termguicolors = false

    -- Remove status line
    vim.o.laststatus = 0

    -- Use low update time
    vim.o.updatetime = 50

    -- Messages from netrw use echoerr
    vim.g.netrw_use_errorwindow = 0

    -- Use system clipboard
    vim.o.clipboard = 'unnamedplus'
end

-- Theme
do
    -- Dark background, required by gruvbox
    vim.o.background = 'dark'

    -- Setup
    local t = require('gruvbox')
    t.setup()
    t.load()
end

-- LSP server configuration
do
    vim.lsp.config.luals = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    }
    vim.lsp.config.rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        single_file_support = true,
        root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },
    }

    -- Enable configs
    for _, lsp in pairs {
        'luals',
        'rust_analyzer'
    } do
        vim.lsp.enable(lsp)
    end
end

do
    --- Toggle whether inlay hints are enabled
    function toggle_inlay_hints()
        local enable = not vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(enable)
        if enable then
            print('enabled inlay hints')
        else
            print('disabled inlay hints')
        end
        return enable
    end

    vim.keymap.set('n', '<C-;>', toggle_inlay_hints)
    vim.keymap.set('i', '<C-;>', toggle_inlay_hints)
end

-- LSP client configuration
do
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client:supports_method('textDocument/implementation') then

            end

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

            -- Autocompletion hints
            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, args.buf)
            end

            -- Symbols on "gs" (gotosymbol)
            if client:supports_method('textDocument/symbols') then
                vim.keymap.set("n", "gs", function()
                    vim.lsp.buf.document_symbol()
                end)
            end
        end,
    })
end

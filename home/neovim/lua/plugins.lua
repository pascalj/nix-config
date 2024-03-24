local bufopts = { noremap = true, silent = true }
local builtin = require('telescope.builtin')
local telescope = require('telescope')
telescope.setup({})
function createSplitWithHeader(bufopts)
    vim.cmd('vsplit')
    vim.cmd.ClangdSwitchSourceHeader(bufopts)
end

-- Plugin Keymap
vim.keymap.set('n', '<leader>ff', builtin.find_files, bufopts)
vim.keymap.set('n', '<C-P>', builtin.git_files, bufopts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, bufopts)
vim.keymap.set('n', '<leader>fc', builtin.lsp_incoming_calls, bufopts)
vim.keymap.set('n', '<leader>fC', builtin.lsp_outgoing_calls, bufopts)
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, bufopts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, bufopts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, bufopts)
vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, bufopts)
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, bufopts)
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, bufopts)
vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, bufopts)
vim.keymap.set('n', '<leader>h', vim.cmd.ClangdSwitchSourceHeader, bufopts)
vim.keymap.set('n', '<leader>H', createSplitWithHeader, bufopts)

local navic = require("nvim-navic")
require("goto-preview").setup {
    -- g(p[dtiDr]|P)
    default_mappings = true
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    -- Finding/diagnostics
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, bufopts)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)

    -- Mutation
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, bufopts)
end

local cmp = require 'cmp'
cmp.setup {
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
    }, {
    { name = 'buffer' },
}
}

require("nvim-autopairs").setup { check_ts = true }
require 'gitsigns'.setup {}
require 'lspconfig'.clangd.setup { on_attach = on_attach, cmd = { "clangd-vim" } }
require 'lspconfig'.lua_ls.setup { on_attach = on_attach }
require 'lspconfig'.ltex.setup {
    on_attach = function(client, buf_nr)
        require("ltex_extra").setup { }
        on_attach(client, buf_nr)
    end,
    settings = {
        ltex = {
            additionalRules = {
                languageModel = '~/.ngrams/',
            },
        },
    },
}
require 'lspconfig'.nil_ls.setup { on_attach = on_attach }
require 'lspconfig'.pyright.setup { on_attach = on_attach }
require 'lspconfig'.smarty_ls.setup { on_attach = on_attach }
require 'lspconfig'.tsserver.setup { on_attach = on_attach }
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true
    },
}

set completeopt-=preview
set shortmess=a
" ----

" Settings
let g:localvimrc_ask=0
let g:localvimrc_sandbox=0
let g:netrw_banner = 0
let g:netrw_list_hide='.*\.swp$,*/tmp/*,*.so,*.swp,^__*,*.zip,*.git,^\.\.\=/\=$,\(^\|\s\s\)\zs\.\S\+'
let g:netrw_sort_sequence = '[\/]$,*,\.o$,\.obj$,\.info$,\.swp$,\.bak$,\~$' 
let g:surround_{char2nr('c')} = "\\\1command\1{\r}"
set directory=$HOME/.vim/swapfiles//
set fillchars="horiz:━,horizup:┻,horizdown:┳,vert:┃,vertleft:┨,vertright:┣,verthoriz:╋"
set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr
set nofoldenable
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set ignorecase
set smartcase
set guicursor

" -- Mappings
let mapleader=","
nmap - :Explore<CR>
nmap _ :Hexplore<CR>
map <Leader>n :noh<CR>
map <Leader>m :MinimapToggle<CR>
map <Leader>j :Make!<CR>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-b> gqip<cr>
nnoremap <C-Left> gT
nnoremap <C-Right> gt

command! -bang GFilesExact call fzf#vim#gitfiles("",  {'options': ['--layout=reverse', '--info=inline']}, 0)

" statusbar
set laststatus=2

" invisibles
nmap <leader>l :set list!<CR>
nmap <leader>p :set invpaste paste?<CR>
nmap <S-TAB> <<
nmap <TAB> >>
vmap <S-TAB> <gv
vmap <TAB> >gv
nmap <CR> o<Esc>

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Enable file type detection
    filetype on
    filetype plugin indent on

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

    set signcolumn=yes

    " Treat .rss files as XML
    autocmd BufNewFile,BufRead *.rss setfiletype xml

    " Focus
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!

    " :help last-position-jump
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

hi clear

if exists("syntax_on")
    syntax reset
endif

" highlight only current buffer/window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

let g:bufferline_echo = 0
set autoindent
set cursorline
set expandtab
set hlsearch
set incsearch
set noshowmode
set number 
set splitbelow
set splitright
set termguicolors

syntax on

" lua part - gradually migrating...
lua << EOF

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

-- Move selected lines with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "Q", "<nop>")

local bufopts = { noremap=true, silent=true }
local builtin = require('telescope.builtin')
local telescope = require('telescope')
telescope.setup({})
function createSplitWithHeader(bufopts)
  vim.cmd('vsplit')
  vim.cmd.ClangdSwitchSourceHeader(bufopts)
end
-- Finding
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
local goto_preview = require("goto-preview").setup {
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
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
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

require("nvim-autopairs").setup {check_ts = true}
require'lspconfig'.clangd.setup{on_attach = on_attach}
require'lspconfig'.smarty_ls.setup{on_attach = on_attach}
require'lspconfig'.tsserver.setup{on_attach = on_attach}
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true
    },
}
    -- Colortheme
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" }, -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    },
    integrations = {
        treesitter = true,
        navic = {
            enabled = true,
            custom_bg = "NONE", -- "lualine" will set background to mantle
        },
    },
    })
    require('lualine').setup({
        options = {
            theme = "catppuccin"
        },
        sections = {
            lualine_c = {
                {
                        'filename'
                },
                {
                        "navic",
                        color_correction = "static",
                        navic_opts = {
                            highlight = true,
                            separator = " -> ",
                        }
                        }
                }
            },
    })
    vim.cmd.colorscheme "catppuccin"
EOF

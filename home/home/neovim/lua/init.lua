-- Options
vim.o.autoindent = true
vim.o.completeopt = "menuone,noselect"
vim.o.cursorline = true
vim.o.directory = vim.fn.expand("~") .. "/.vim/swapfiles//"
vim.o.expandtab = true
vim.o.fillchars = "horiz:━,horizup:┻,horizdown:┳,vert:┃,vertleft:┨,vertright:┣,verthoriz:╋"
vim.o.foldenable = false
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.nu = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shortmess = "a"
vim.o.showmode = false
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip"

-- Global variables
vim.g.bufferline_echo = 0
vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = '.*\\.swp$,*/tmp/*,*.so,*.swp,^__*,*.zip,*.git,^\\.\\.=/\\=$,\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'
vim.g.netrw_sort_sequence = '[\\/]$,*\\.o$,*\\.obj$,*\\.info$,*\\.swp$,*\\.bak$,*~$'
vim.g["surround_" .. vim.fn.char2nr('c')] = "\\\1command\1{\\r}"

-- Mappings
vim.g.mapleader = ","
vim.api.nvim_set_keymap('', '<C-b>', 'gqip<CR>', { noremap = true })
vim.api.nvim_set_keymap('', '<C-h>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('', '<C-l>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '-', ':Explore<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Left>', 'gT', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', 'gt', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<CR>', 'o<Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>j', ':Make!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>m', ':MinimapToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>n', ':noh<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-TAB>', '<<', { noremap = true })
vim.api.nvim_set_keymap('n', '<TAB>', '>>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':set list!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':set invpaste paste?<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'Q', '<nop>', {})
vim.api.nvim_set_keymap('n', '_', ':Hexplore<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<S-TAB>', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<TAB>', '>gv', { noremap = true })
-- Move selected lines with J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Highlight only the current buffer/window
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    command = "setlocal cursorline"
})
vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    command = "setlocal nocursorline"
})

-- Commands
vim.api.nvim_create_user_command('GFilesExact', function()
    vim.fn['fzf#vim#gitfiles']("", { options = { '--layout=reverse', '--info=inline' } }, 0)
end, { bang = true })

-- Plugins
require('plugins')
require('color')

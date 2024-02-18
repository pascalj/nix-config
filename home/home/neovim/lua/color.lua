require("catppuccin").setup({
    flavour = "mocha",             -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
    term_colors = false,           -- sets terminal colors (e.g. `g:terminal_color_0`)
    no_italic = false,             -- Force no italic
    no_bold = false,               -- Force no bold
    -- no_underline = false,          -- Force no underline
    styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" },   -- Change the style of comments
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
        native_lsp = {
            enabled = true,
            underlines = {
                errors = { "undercurl" },
                hints = { "undercurl" },
                warnings = { "undercurl" },
                information = { "undercurl" },
            },
        },
        telescope = {
            enabled = true,
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

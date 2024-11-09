return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1001,
        config = function()
            require('kanagawa').setup{
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                statementStyle = { bold = false },
                undercurl = false,
                transparent = true,
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Boolean = { bold = false },
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                    }
                end,
            }
            vim.cmd('colorscheme kanagawa')
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = {
                theme = require("lualine_themes").kanagawa,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            }
            opts.sections = {
                lualine_z = { "location" },
            }
        end,
    },
    {
        "fladson/vim-kitty",
        lazy = false,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            indent = {
                char = "╎",
                tab_char = "╎",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
    },
    {
        "echasnovski/mini.indentscope",
        version = false,
        opts = function(_, opts)
            local indent = require("mini.indentscope")
            opts.delay = 0
            opts.symbol = "╎"
            opts.options = { try_as_border = true }
            opts.draw = { animation = indent.gen_animation.none() }
        end,
    }
}

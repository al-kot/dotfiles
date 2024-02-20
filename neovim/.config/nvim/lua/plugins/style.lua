return {
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        opts = function(_, opts)
            opts.transparent = true
            opts.colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                            float = {
                                bg = "none",
                            },
                        },
                    },
                },
            }
        end,
        -- config = function()
        --     vim.cmd([[colorscheme kanagawa]])
        -- end
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            require("everforest").setup({
                -- Your config here
                transparent_background_level = 2,
                ui_contrast = "high"
            })
            vim.cmd([[colorscheme everforest]])
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = {
                theme = require("lualine_themes").everforest,
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
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
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
        main = "ibl",
    },
    {
        "echasnovski/mini.indentscope",
        version = false, -- wait till new 0.7.0 release to put it back on semver
        opts = function(_, opts)
            local indent = require("mini.indentscope")
            opts.delay = 0
            opts.symbol = "╎"
            -- symbol = "▏"
            opts.options = { try_as_border = true }
            opts.draw = { animation = indent.gen_animation.none() }
        end,
        -- config = function()
        --     require('mini.indentscope').gen_animation.none()
        -- end
    }
}

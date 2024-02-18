local colors = {
    black = '#727169',
    red = '#e82424',
    green = '#98bb6c',
    yellow = '#e6c384',
    blue = '#7fb4ca',
    magenta = '#938aa9',
    cyan = '#7aa89f',
    white = '#dcd7ba',
    purple = "#c792ea",
}

local lualine = {
    night = {
        normal = {
            a = { fg = colors.purple, bg = "none", gui = "bold" },
            b = { fg = colors.magenta, bg = "none" }, --colors.menu_grey },
            c = { fg = colors.yellow, bg = "none" },  --colors.black },
        },
        insert = {
            a = { fg = colors.blue, bg = "none", gui = "bold" },
            b = { fg = colors.blue, bg = "none" }, --colors.menu_grey },
        },
        visual = {
            a = { fg = colors.cyan, bg = "none", gui = "bold" },
            b = { fg = colors.cyan, bg = "none" }, --colors.menu_grey },
        },
        replace = {
            a = { fg = colors.green, bg = "none", gui = "bold" },
            b = { fg = colors.green, bg = "none" }, --colors.menu_grey },
        },
        inactive = {
            a = { fg = colors.white, bg = "none", gui = "bold" },
            b = { fg = colors.black, bg = "none" }, --colors.menu_grey },
            c = { fg = colors.black, bg = "none" }, --colors.menu_grey },
        },
    },
}

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
        config = function()
            vim.cmd([[colorscheme kanagawa]])
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = {
                theme = lualine.night,
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
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gs"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            indent = {
                char = "▏",
                tab_char = "▏",
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
        opts = function (_, opts)
            local indent = require("mini.indentscope")
            opts.delay = 0
            opts.symbol = "▏"
            -- symbol = "│"
            opts.options = { try_as_border = true }
            opts.draw = { animation = indent.gen_animation.none() }
        end,
        -- config = function()
        --     require('mini.indentscope').gen_animation.none()
        -- end
    }
}

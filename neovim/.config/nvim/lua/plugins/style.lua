local colors = {
    night = {
        vertsplit = "#181A1F",
        special_grey = "#3B4048",
        menu_grey = "#3E4452",
        cursor_grey = "#2C323C",
        gutter_fg_grey = "#4B5263",
        blue = "#82b1ff",
        dark_red = "#BE5046",
        white = "#bfc7d5",
        green = "#C3E88D",
        purple = "#c792ea",
        yellow = "#ffcb6b",
        light_red = "#ff869a",
        red = "#ff5370",
        dark_yellow = "#F78C6C",
        cyan = "#89DDFF",
        comment_grey = "#697098",
        black = "#292D3E",
    },
    kanagawa = require("colors.themes"), -- {
    --     black = "#a6a69c",
    --     red = "#E46876",
    --     green = "#87a987",
    --     yellow = "#E6C384",
    --     blue = "#7FB4CA",
    --     magenta = "#938AA9",
    --     cyan = "#7AA89F",
    --     white = "#c5c9c5",
    -- },
}

local lualine = {
    night = {
        normal = {
            a = { fg = colors.night.purple, bg = nil, gui = "bold" },
            b = { fg = colors.night.purple, bg = nil }, --colors_night.menu_grey },
            c = { fg = colors.night.comment_grey, bg = nil }, --colors_night.black },
        },
        insert = {
            a = { fg = colors.night.blue, bg = nil, gui = "bold" },
            b = { fg = colors.night.blue, bg = nil }, --colors_night.menu_grey },
        },
        visual = {
            a = { fg = colors.night.cyan, bg = nil, gui = "bold" },
            b = { fg = colors.night.cyan, bg = nil }, --colors_night.menu_grey },
        },
        replace = {
            a = { fg = colors.night.green, bg = nil, gui = "bold" },
            b = { fg = colors.night.green, bg = nil }, --colors_night.menu_grey },
        },
        inactive = {
            a = { fg = colors.night.menu_grey, bg = nil, gui = "bold" },
            b = { fg = colors.night.black, bg = nil }, --colors_night.menu_grey },
            c = { fg = colors.night.black, bg = nil }, --colors_night.menu_grey },
        },
    },
    -- kanagawa = {
    --     normal = {
    --         a = { fg = colors.kanagawa.syn, bg = nil, gui = "bold" },
    --         b = { fg = colors.kanagawa.syn, bg = nil }, --colors_kanagawa.menu_grey },
    --         c = { fg = colors.kanagawa.black, bg = nil }, --colors_kanagawa.black },
    --     },
    --
    --     insert = {
    --         a = { fg = colors.kanagawa.blue, bg = nil, gui = "bold" },
    --         b = { fg = colors.kanagawa.blue, bg = nil }, --colors_kanagawa.menu_grey },
    --     },
    --     visual = {
    --         a = { fg = colors.kanagawa.cyan, bg = nil, gui = "bold" },
    --         b = { fg = colors.kanagawa.cyan, bg = nil }, --colors_kanagawa.menu_grey },
    --     },
    --     replace = {
    --         a = { fg = colors.kanagawa.green, bg = nil, gui = "bold" },
    --         b = { fg = colors.kanagawa.green, bg = nil }, --colors_kanagawa.menu_grey },
    --     },
    --     inactive = {
    --         a = { fg = colors.kanagawa.black, bg = nil, gui = "bold" },
    --         b = { fg = colors.kanagawa.black, bg = nil }, --colors_kanagawa.menu_grey },
    --         c = { fg = colors.kanagawa.black, bg = nil }, --colors_kanagawa.menu_grey },
    --     },
    -- },
}

return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            opts.options = {
                theme = require("colors.themes"),
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            }
            opts.sections = {
                lualine_z = { "location" },
            }
        end,
    },
    {
        "folke/tokyonight.nvim",
        opts = {
            terminal_colors_night = true,
            style = "night",
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            dim_inactive = true,
            on_colors_night = function(colors_night)
                colors_night.bg_statusline = "#ff00ff"
            end,
        },
    },
    {
        "fladson/vim-kitty",
        lazy = false,
    },
}

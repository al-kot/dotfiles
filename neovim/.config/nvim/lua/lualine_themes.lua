local colors = {
    kanagawa = {
        black = '#727169',
        red = '#e82424',
        green = '#98bb6c',
        yellow = '#e6c384',
        blue = '#7fb4ca',
        magenta = '#938aa9',
        cyan = '#7aa89f',
        white = '#dcd7ba',
        purple = "#c792ea",
    },
    everforest = {
        fg = "#d3c6aa",
        red = "#e67e80",
        orange = "#e69875",
        yellow = "#dbbc7f",
        green = "#a7c080",
        aqua = "#83c092",
        blue = "#7fbbb3",
        purple = "#d699b6",
        grey0 = "#7a8478",
        grey1 = "#859289",
        grey2 = "#9da9a0",
        statusline1 = "#a7c080",
        statusline2 = "#d3c6aa",
        statusline3 = "#e67e80",
        none = "NONE",
    },
}

return {
    kanagawa = {
        normal = {
            a = { fg = colors.kanagawa.cyan, bg = "none", gui = "bold" },
            b = { fg = colors.kanagawa.magenta, bg = "none" }, --colors.kanagawa.menu_grey },
            c = { fg = colors.kanagawa.yellow, bg = "none" },  --colors.kanagawa.black },
        },
        insert = {
            a = { fg = colors.kanagawa.blue, bg = "none", gui = "bold" },
            b = { fg = colors.kanagawa.blue, bg = "none" }, --colors.kanagawa.menu_grey },
        },
        visual = {
            a = { fg = colors.kanagawa.purple, bg = "none", gui = "bold" },
            b = { fg = colors.kanagawa.purple, bg = "none" }, --colors.kanagawa.menu_grey },
        },
        replace = {
            a = { fg = colors.kanagawa.green, bg = "none", gui = "bold" },
            b = { fg = colors.kanagawa.green, bg = "none" }, --colors.kanagawa.menu_grey },
        },
        inactive = {
            a = { fg = colors.kanagawa.white, bg = "none", gui = "bold" },
            b = { fg = colors.kanagawa.black, bg = "none" }, --colors.kanagawa.menu_grey },
            c = { fg = colors.kanagawa.black, bg = "none" }, --colors.kanagawa.menu_grey },
        },
    },
    everforest = {
        normal = {
            a = { fg = colors.everforest.yellow, bg = "none", gui = "bold" },
            b = { fg = colors.everforest.yellow, bg = "none" }, --colors.menu_grey },
            c = { fg = colors.everforest.orange, bg = "none" }, --colors.black },
        },
        insert = {
            a = { fg = colors.everforest.aqua, bg = "none", gui = "bold" },
            b = { fg = colors.everforest.yellow, bg = "none" }, --colors.menu_grey },
        },
        visual = {
            a = { fg = colors.everforest.statusline3, bg = "none", gui = "bold" },
            b = { fg = colors.everforest.yellow, bg = "none" }, --colors.menu_grey },
        },
        replace = {
            a = { fg = colors.everforest.green, bg = "none", gui = "bold" },
            b = { fg = colors.everforest.yellow, bg = "none" }, --colors.menu_grey },
        },
        inactive = {
            a = { fg = colors.everforest.grey1, bg = "none", gui = "bold" },
            b = { fg = colors.everforest.grey2, bg = "none" }, --colors.menu_grey },
            c = { fg = colors.everforest.grey2, bg = "none" }, --colors.menu_grey },
        },

    }
}

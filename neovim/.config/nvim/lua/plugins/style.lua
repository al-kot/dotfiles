return {
    {
        "folke/tokyonight.nvim",
        opts = {
            terminal_colors = true,
            style = "night",
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
            dim_inactive = true,
            on_colors = function(colors)
                colors.bg_statusline = "#ff00ff"
            end,
        },
    },
    {
        "fladson/vim-kitty",
        lazy = false,
    }
}

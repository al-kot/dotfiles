return {
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    {
        "norcalli/nvim-colorizer.lua",
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        enabled = true,
    },
    {
        'glacambre/firenvim',
        build = ":call firenvim#install(0)",
    },
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- required by telescope
            "MunifTanjim/nui.nvim",

            -- optional
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            -- configuration goes here
            theme = {
                [""] = {
                    bg = "#000000"
                },
            },
        },
    }
}

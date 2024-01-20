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
        "rebelot/kanagawa.nvim",
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
    },
}

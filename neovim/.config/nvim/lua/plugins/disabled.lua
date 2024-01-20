local plugins = {
    "nvim-pack/nvim-spectre",
    "dstein64/vim-startuptime",
    -- "stevearc/aerial.nvim",
    "echasnovski/mini.comment",
    "echasnovski/mini.ai",
    "echasnovski/mini.pairs",
    -- "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "nvim-neo-tree/neo-tree.nvim",
    "nvim-pack/nvim-spectre",
    "lewis6991/gitsigns.nvim",
    "echasnovski/mini.bufremove",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "rcarriga/nvim-notify",
    "stevearc/dressing.nvim",
    "folke/noice.nvim",
    "MunifTanjim/nui.nvim",
    "nvimdev/dashboard-nvim",
    "goolord/alpha-nvim",
    "folke/flash.nvim",
}

To_disbable = {}

for _, p in ipairs(plugins) do
    table.insert(To_disbable, { p, enabled = false })
end

return {
    To_disbable,
}

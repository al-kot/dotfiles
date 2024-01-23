return {
    {
        "hrsh7th/nvim-cmp",
        event = "VeryLazy",
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
            })
            -- opts.sources = cmp.config.sources({ name = "vim-dadbod-completion" })
        end,
    },
}

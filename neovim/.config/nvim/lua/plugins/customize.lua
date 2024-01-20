return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
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
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local config = require("lspconfig")
            for _, serv in ipairs(opts.servers) do
                serv.mason = false
            end
            -- code
        end,
    },
    {
        "rcarriga/nvim-notify",
        opts = {
            max_height = function()
                return math.floor(vim.o.lines * 0.3)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.3)
            end,
        },
    },
}

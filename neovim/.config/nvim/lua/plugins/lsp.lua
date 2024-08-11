return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        opts = {
            ensure_installed = {
                "pylsp",
                "clangd",
                "lua_ls",
                "rust_analyzer",
            },
        }
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function(_, opts)
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                -- formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-l>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-m>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm({ select = false })
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                        { name = 'buffer' },
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        lazy = false,
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function(_, opts)
            -- Setup language servers.
            local lspconfig = require('lspconfig')
            lspconfig.lua_ls.setup {}
            lspconfig.rust_analyzer.setup {
                on_attach = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
            }
            lspconfig.clangd.setup {
                on_attach = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
            }
            lspconfig.pylyzer.setup {
            }
        end,
    },
}

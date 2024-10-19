return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "rust", "python", "apex", "soql" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
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
        event = { 'BufReadPre', 'BufNewFile' },
        lazy = false,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function(_, opts)
            require('mason-lspconfig').setup({
                ensure_installed = {
                    "pylsp",
                    "clangd",
                    "jsonls",
                    "rust_analyzer",
                    "lua_ls",
                },
                inlay_hints = { enabled = true },
            })

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
            lspconfig.pylsp.setup{}
            lspconfig.ccls.setup{
                on_attach = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
            }
            lspconfig.ts_ls.setup {
                on_attach = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
            }
            lspconfig.tailwindcss.setup {
                on_attach = function()
                    vim.lsp.inlay_hint.enable(true)
                end,
            }
            lspconfig.svelte.setup{}
            lspconfig.gopls.setup{}
        end,
    }
}

local function lsp_servers()
    local servers = {
        clangd = {},
        jsonls = {},
        rust_analyzer = {},
        templ = {},
        gopls = {},
        bashls = {},
        yamlls = {},
        ts_ls = {},
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        },
        pyright = {
            settings = {
                python = {
                    analysis = {
                        diagnosticMode = "openFilesOnly",
                        diagnosticSeverityOverrides = {
                            reportUnusedExpression = "none",
                        },
                    },
                },
            },
        },
        -- pylsp = {
        --     settings = {
        --         pylsp = {
        --             plugins = {
        --                 pyflakes = { enabled = false },
        --                 flake8 = { enabled = false },
        --                 pylint = { enabled = false },
        --                 pylance = { enabled = false },
        --                 pycodestyle = { enabled = false },
        --             },
        --         },
        --     },
        -- },
        tailwindcss = {
            filetypes = { "templ", "astro", "javascript", "typescript", "react", "typescriptreact" },
            settings = {
                tailwindCSS = {
                    includeLanguages = {
                        templ = "html",
                    },
                },
            },
        },
        html = {
            filetypes = { "html", "templ" }
        },
        htmx = {
            filetypes = { "html", "templ" }
        },
    }

    local names = {}
    for name, _ in pairs(servers) do
        table.insert(names, name)
    end
    return servers, names
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "css", "rust", "python", "apex", "soql" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = false, -- you can change this if you want.
                        goto_next_end = {
                            --- ... other keymaps
                            [")"] = { query = "@code_cell.inner", desc = "next code block" },
                        },
                        goto_previous_start = {
                            --- ... other keymaps
                            ["("] = { query = "@code_cell.inner", desc = "previous code block" },
                        },
                    },
                    select = {
                        enable = true,
                        lookahead = true, -- you can change this if you want
                        keymaps = {
                            --- ... other keymaps
                            ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                            ["ab"] = { query = "@code_cell.outer", desc = "around block" },
                        },
                    },
                }
            })
        end
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        lazy = false,
        dependencies = {
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function(_, opts)
            local caps = require('blink.cmp').get_lsp_capabilities()

            local servers, names = lsp_servers()

            require('mason-lspconfig').setup({
                ensure_installed = names,
                capabilities = caps,
                automatic_enable = {
                    exclude = names,
                }
            })

            for name, config in pairs(servers) do
                if config then
                    vim.lsp.config(name, config)
                end
                vim.lsp.enable(name)
            end
        end,
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },

        config = function(_, opts)
            require('conform').formatters.injected = {
                -- Set the options field
                options = {
                    -- Set to true to ignore errors
                    ignore_errors = false,
                    -- Map of treesitter language to file extension
                    -- A temporary file name with this extension will be generated during formatting
                    -- because some formatters care about the filename.
                    lang_to_ext = {
                        bash = 'sh',
                        c_sharp = 'cs',
                        elixir = 'exs',
                        javascript = 'js',
                        julia = 'jl',
                        latex = 'tex',
                        markdown = 'md',
                        python = 'py',
                        ruby = 'rb',
                        rust = 'rs',
                        teal = 'tl',
                        r = 'r',
                        typescript = 'ts',
                    },
                    -- Map of treesitter language to formatters to use
                    -- (defaults to the value from formatters_by_ft)
                    lang_to_formatters = {},
                },
            }
            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_format = "fallback", range = range })
            end, { range = true })
        end,

        keys = {
            { '<leader>f', '<cmd>Format<cr>' }
        }
    }
}

return {
    {
        "numToStr/Comment.nvim",
        opts = {
            toggler = {
                line = '<leader>c',
            },
            opleader = {
                line = '<leader>c',
            },
        },
        lazy = false,
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
            { 'tpope/vim-dadbod',                     lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    {
        "karb94/neoscroll.nvim",
        lazy = false,
        opts = {
            duration_multiplier = 0.4,
        }
    },
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        opts = {
            global_keymaps = {
                ["Send request"] = { -- sets global mapping
                    "<leader>Rs",
                    function() require("kulala").run() end,
                    mode = { "n", "v" },  -- optional mode, default is n
                    desc = "Send request" -- optional description, otherwise inferred from the key
                },
                ["Send all requests"] = {
                    "<leader>Ra",
                    function() require("kulala").run_all() end,
                    mode = { "n", "v" },
                    ft = "http", -- sets mapping for *.http files only
                },
                ["Replay the last request"] = {
                    "<leader>Rr",
                    function() require("kulala").replay() end,
                    ft = { "http", "rest" }, -- sets mapping for specified file types
                },
                ["Find request"] = false     -- set to false to disable
            },
            global_keymaps_prefix = "<leader>R",
            kulala_keymaps_prefix = "",
            ui = {
                show_request_summary = false,
                icons = {
                    inlay = {
                        loading = "󰚭",
                        done = "",
                        error = "",
                    },
                },
            }
        },
    },
}

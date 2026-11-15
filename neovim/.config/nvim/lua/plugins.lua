local utils = require("utils")

vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets.git",
})

vim.pack.add({
    "https://github.com/stevearc/conform.nvim.git",
})
require("conform").setup({
    formatters = {
        kulala = {
            command = "kulala-fmt",
            args = { "format", "$FILENAME" },
            stdin = false,
        },
        sqlfluff = {
            command = "sqlfluff",
            args = { "format", "--dialect=postgres", "-" },
            stdin = true,
            cwd = function()
                return vim.fn.getcwd()
            end,
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        c = { "clangd" },
        typst = { "typstyle" },
        http = { "kulala" },
        sql = { "sqlfluff" },
        json = { "fixjson" },
    },
})

utils.add_keybinds({
    {
        "n",
        "<leader>f",
        function()
            require("conform").format({ lsp_format = "fallback" })
        end,
    },
})

vim.pack.add({
    "https://github.com/rebelot/kanagawa.nvim.git",
})
require("kanagawa").setup({
    transparent = true,
    theme = "dragon",
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    statementStyle = { bold = false, italic = false },
    functionStyle = { italic = false },
    typeStyle = { italic = false },
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            CursorLineNr = { bg = "none", fg = "#e6c384" },
            ["@variable.builtin"] = { italic = false },
            Pmenu = { fg = theme.ui.shade0, bg = "none" }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
        }
    end,
})
vim.cmd.colorscheme("kanagawa-dragon")

vim.pack.add({
    "https://github.com/folke/snacks.nvim.git",
})
require("snacks").setup({
    image = {
        enabled = true,
        doc = {
            enabled = true,
            inline = false,
            max_width = 100,
            max_height = 100,
        },
        math = {
            enabled = true,
        },
    },
    picker = {
        matcher = {
            frecency = true,
        },
        win = {
            input = {
                keys = {
                    -- ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                },
            },
        },
        layout = {
            preset = "ivy",
        },
    },
    explorer = {
        enabled = true,
    },
})
utils.add_keybinds({
    {
        "n",
        "<leader><leader>",
        function()
            Snacks.picker.files({ hidden = true })
        end,
    },
    {
        "n",
        "<leader>g",
        function()
            Snacks.picker.grep({ hidden = true })
        end,
    },
    { "n", "<leader>h", Snacks.picker.help },
    { "n", "<leader>b", Snacks.picker.buffers },
    { "n", "<leader>n", Snacks.picker.lines },
    {
        "n",
        "<leader>e",
        function()
            Snacks.picker.explorer({ auto_close = true, hidden = true, layout = { preset = "ivy", preview = true } })
        end,
    },
})

vim.pack.add({ "https://github.com/saghen/blink.lib", "https://github.com/saghen/blink.cmp" })
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup()
cmp.setup({
    keymap = { preset = "default" },
    appearance = {
        nerd_font_variant = "mono",
    },
    completion = {
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            llama = {
                name = "Llama",
                module = "llama.fim_source", -- blink calls require('llama.fim_source').new(opts)
                opts = {
                    -- endpoint_fim etc. come from g:llama_config / vim.g.llama_config
                },
            },
        },
    },
    cmdline = {
        enabled = true,
    },
    signature = {
        enabled = true,
    },
    fuzzy = { implementation = "prefer_rust" },
})

utils.set_hl({
    { "BlinkCmpMenuBorder", { link = "Pmenu" } },
})

vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", version = "main" },
})
require("nvim-treesitter").install({
    "c",
    "cpp",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    "html",
    "css",
    "rust",
    "python",
    "latex",
    "http",
    "zig",
})

-- require("leap").set_default_mappings()
vim.pack.add({
    "https://codeberg.org/andyg/leap.nvim",
})
require("leap").opts.labels = "nehmluyotsrvcdpfwNEIMHLUYOTSRVCPFWDA"
require("leap").opts.safe_labels = "nehmluotsdfw"
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")

vim.pack.add({
    "https://github.com/mrjones2014/smart-splits.nvim.git",
})
local splits = require("smart-splits")
utils.add_keybinds({
    { "n", "<C-h>", splits.move_cursor_left },
    { "n", "<C-j>", splits.move_cursor_down },
    { "n", "<C-k>", splits.move_cursor_up },
    { "n", "<C-l>", splits.move_cursor_right },
    { "n", "<C-S-h>", splits.resize_left },
    { "n", "<C-S-j>", splits.resize_down },
    { "n", "<C-S-k>", splits.resize_up },
    { "n", "<C-S-l>", splits.resize_right },
})

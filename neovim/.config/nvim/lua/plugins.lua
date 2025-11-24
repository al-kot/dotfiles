local utils = require("utils")

vim.pack.add({
    "https://github.com/ellisonleao/gruvbox.nvim.git",

    "https://github.com/stevearc/oil.nvim.git",
    "https://github.com/numToStr/Comment.nvim.git",
    "https://github.com/folke/snacks.nvim.git",
    "https://github.com/ggandor/leap.nvim.git",
    "https://github.com/mrjones2014/smart-splits.nvim.git",
    "https://github.com/nvim-treesitter/nvim-treesitter.git",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git",
    "https://github.com/rafamadriz/friendly-snippets.git",
    { src = "https://github.com/Saghen/blink.cmp.git", version = vim.version.range("1.*") },
    "https://github.com/stevearc/conform.nvim.git",
    "https://github.com/whonore/Coqtail.git",
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

require("gruvbox").setup({
    transparent_mode = true,
    italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
    },
})
vim.cmd("colorscheme gruvbox")
vim.cmd(":hi statusline guibg=NONE")

require("oil").setup({
    view_options = {
        show_hidden = false,
        is_hidden_file = function(_, _)
            return false
        end,
    },
    keymaps = {
        ["<C-h>"] = false,
    },
})
utils.add_keybinds({
    {
        "n",
        "<leader>e",
        function()
            require("oil").open(nil, { preview = {} }, function()
                vim.api.nvim_win_set_width(0, 40)
            end)
        end,
    },
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
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                    ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                },
            },
        },
        layout = {
            preset = "left",
        },
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
})

require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
        nerd_font_variant = "mono",
    },
    completion = {
        menu = { border = "rounded", winhighlight = "Pmenu:BlinkCmpMenu" },
        documentation = { auto_show = true, window = { border = "rounded" } },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
            jupynium = {
                name = "Jupynium",
                module = "jupynium.blink_cmp",
                -- Consider higher priority than LSP
                score_offset = 100,
            },
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
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

require("nvim-treesitter.configs").setup({
    ensure_installed = {
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
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})

require("leap").set_default_mappings()
require("leap").opts.labels = "nehmluyotsrvcdpfwNEIMHLUYOTSRVCPFWDA"
require("leap").opts.safe_labels = "nehmluotsdfw"

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

require("Comment").setup({
    toggler = {
        line = "<leader>c",
    },
    opleader = {
        line = "<leader>c",
    },
})

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim.git",
    { src = "https://github.com/ThePrimeagen/harpoon.git", version = "harpoon2" },
})
local harpoon = require("harpoon")
harpoon:setup()
-- stylua: ignore
utils.add_keybinds({
    { "n", "<leader>a", function() harpoon:list():add() end },
    { "n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end },
})
-- stylua: ignore
for i = 1, 9 do
    utils.add_keybinds({
        { "n", "<leader>" .. i, function() harpoon:list():select(i) end },
    })
end

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
    "https://github.com/mistweaverco/kulala.nvim.git",
    "https://github.com/kiyoon/jupynium.nvim.git",
    "https://github.com/whonore/Coqtail.git",
})

require("kulala").setup({
    global_keymaps = true,
    global_keymaps_prefix = "<leader>r",
    ui = {
        default_view = "body",
        show_request_summary = false,
        winbar = false,
    },
})

require("jupynium").setup({
    default_notebook_URL = "localhost:8888",
    firefox_profile_name = "default-release",
    firefox_profiles_ini_path = vim.fn.has("macunix") and "~/Library/Application Support/Firefox/profiles.ini"
        or "~/.mozilla/firefox/profiles.ini",
    -- firefox_profiles_ini_path = '~/.mozilla/firefox/profiles.ini',
    use_default_keybindings = false,
    textobjects = {
        use_default_keybindings = false,
    },
})
utils.add_keybinds({
    {
        { "x", "o" },
        "iC",
        function()
            require("jupynium.textobj").select_cell(false, true)
        end,
    },
    {
        { "x", "o" },
        "aC",
        function()
            require("jupynium.textobj").select_cell(true, true)
        end,
    },
    {
        { "x", "o" },
        "ic",
        function()
            require("jupynium.textobj").select_cell(false, false)
        end,
    },
    {
        { "x", "o" },
        "ac",
        function()
            require("jupynium.textobj").select_cell(true, false)
        end,
    },
    {
        { "n", "x", "o" },
        "<space>jj",
        function()
            require("jupynium.textobj").goto_current_cell_separator()
        end,
    },
    {
        { "n", "x", "o" },
        ")",
        function()
            require("jupynium.textobj").goto_next_cell_separator()
        end,
    },
    {
        { "n", "x", "o" },
        "(",
        function()
            require("jupynium.textobj").goto_previous_cell_separator()
        end,
    },
    {
        "n",
        "<leader>nr",
        ":JupyniumExecuteSelectedCells<CR>:lua require('jupynium.textobj').goto_next_cell_separator()<CR>",
    },
    -- { "n", "<leader>r", ":JupyniumExecuteSelectedCells<CR>" },
    { "n", "<leader>na", ":JupyniumStartAndAttachToServer<CR>" },
    { "n", "<leader>ns", ":JupyniumStartSync " },
    { "n", "<leader>nc", "o<CR># %%<CR>" },
})
utils.set_hl({
    { "JupyniumMarkdownCellContent", { bg = "none" } },
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
    { "n", "<leader>e", ":Oil<CR>" },
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
        providers = {
            jupynium = {
                name = "Jupynium",
                module = "jupynium.blink_cmp",
                -- Consider higher priority than LSP
                score_offset = 100,
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

vim.pack.add({ "https://github.com/al-kot/typst-preview.nvim.git" })
local typst = require("typst-preview")
typst.setup({
    preview = {
        position = "right",
        ppi = 144,
        max_width = 80,
    },
})
-- stylua: ignore
utils.add_keybinds({
    { "n", "<leader>tn",  function() typst.next_page() end, },
    { "n", "<leader>te",  function() typst.prev_page() end, },
    { "n", "<leader>tgg", function() typst.first_page() end, },
    { "n", "<leader>tG",  function() typst.last_page() end, },
    { "n", "<leader>td",  function() typst.stop() end, },
    { "n", "<leader>to",  function() typst.start() end, },
    { "n", "<leader>tr",  function() typst.refresh() end, },
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

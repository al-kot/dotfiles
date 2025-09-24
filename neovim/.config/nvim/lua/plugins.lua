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

    -- jupyter
    "https://github.com/GCBallesteros/jupytext.nvim.git",
    "https://github.com/jmbuhr/otter.nvim.git",
    "https://github.com/quarto-dev/quarto-nvim.git",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
    "https://github.com/aleshasuqa/molten-nvim.git",
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
            inline = true,
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
    textobjects = {
        move = {
            enable = true,
            set_jumps = false,
            goto_next_end = {
                [")"] = { query = "@code_cell.inner", desc = "next code block" },
            },
            goto_previous_start = {
                ["("] = { query = "@code_cell.inner", desc = "previous code block" },
            },
        },
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                --- ... other keymaps
                ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                ["ab"] = { query = "@code_cell.outer", desc = "around block" },
            },
        },
    },
})

require("leap").set_default_mappings()
require("leap").opts.labels = "nehmluyotsrvcdpfwNEIMHLUYOTSRVCPFWDA"
require("leap").opts.safe_labels = "nehmluotsdfw"

local splits = require("smart-splits")
utils.add_keybinds({
    { "n", "<A-h>", splits.move_cursor_left },
    { "n", "<A-n>", splits.move_cursor_down },
    { "n", "<A-e>", splits.move_cursor_up },
    { "n", "<A-i>", splits.move_cursor_right },
    { "n", "<C-h>", splits.resize_left },
    { "n", "<C-n>", splits.resize_down },
    { "n", "<C-e>", splits.resize_up },
    { "n", "<C-i>", splits.resize_right },
})

require("Comment").setup({
    toggler = {
        line = "<leader>c",
    },
    opleader = {
        line = "<leader>c",
    },
})

require("jupytext").setup({
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
})

require("quarto").setup({
    lspFeatures = {
        languages = { "python" },
        chunks = "all",
        diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
        },
        completion = {
            enabled = true,
        },
    },
    keymap = {
        hover = "E",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
    },
    codeRunner = {
        enabled = true,
        default_method = "molten",
    },
})
local runner = require("quarto.runner")
utils.add_keybinds({
    { "n", "<leader><CR>", runner.run_cell, { desc = "run cell", silent = true } },
    { "n", "<leader>ra", runner.run_all, { desc = "run all cells", silent = true } },
    { "n", "<leader>rl", runner.run_line, { desc = "run line", silent = true } },
    { "n", "<leader>r", runner.run_cell, { desc = "run visual range", silent = true } },
    { "v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true } },
})

require("render-markdown").setup({
    render_modes = true,
    overrides = {
        buftype = {
            nofile = {
                enabled = true,
                heading = {
                    -- enabled = false,
                    width = "block",
                    border = false,
                    border_virtual = false,
                    left_pad = 0,
                    right_pad = 0,
                    left_margin = 0,
                    position = "inline",
                    icons = { "" },
                    sign = false,
                    min_width = 0,
                    backgrounds = false,
                },
                code = {
                    disable_background = true,
                    highlight_inline = "RenderMarkdownCodeInlineNoFile",
                    language = false,
                    style = "normal",
                    border = "hide",
                },
            },
        },
    },
    code = {
        style = "normal",
        border = "thick",
    },
    heading = {
        width = "block",
        border = true,
        border_virtual = true,
        left_pad = 3,
        right_pad = 3,
        left_margin = 7,
        position = "inline",
        icons = false,
        min_width = 30,
    },
})
utils.set_hl({
    { "RenderMarkdownCode", { bg = "#282828" } },
    { "RenderMarkdownCodeInLineNoFile", { bg = "none", fg = "#d65d0e" } },
    { "RenderMarkdownH1Bg", { bg = "#458588", fg = "#282828" } },
    { "RenderMarkdownH2Bg", { bg = "#689d6a", fg = "#282828" } },
    { "RenderMarkdownH3Bg", { bg = "#98971a", fg = "#282828" } },
    { "RenderMarkdownH4Bg", { bg = "#b16286", fg = "#282828" } },
    { "RenderMarkdownH5Bg", { bg = "#458588", fg = "#282828" } },
    { "RenderMarkdownH6Bg", { bg = "#689d6a", fg = "#282828" } },
})

local molten_gs = {
    molten_image_provider = "snacks.nvim",
    molten_wrap_output = true,
    molten_virt_text_max_lines = 999,
    molten_virt_text_output = true,
    molten_output_virt_lines = false,
    molten_virt_lines_off_by_1 = true,
    molten_auto_open_output = false,
    molten_output_win_hide_on_leave = false,
}
utils.fill_table(vim.g, molten_gs)
utils.set_hl({
    { "MoltenCell", { bg = "NONE" } },
})
local imb = function()
    vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        if vim.tbl_contains(kernels, "python311") then
            vim.cmd("MoltenInit python311")
            vim.cmd("MoltenImportOutput")
        end
    end)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.ipynb",
    callback = function()
        require("quarto").activate()
        if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then imb() end
    end,
})

vim.api.nvim_create_autocmd("BufAdd", {
    pattern = { "*.ipynb" },
    callback = imb,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.ipynb" },
    callback = function()
        if require("molten.status").initialized() == "Molten" then vim.cmd("MoltenExportOutput!") end
    end,
})

vim.pack.add({ "https://github.com/al-kot/typst-preview.nvim.git" })
local typst = require("typst-preview")
typst.setup({
    preview = {
        position = "right",
        ppi = 196,
    },
})
-- stylua: ignore
utils.add_keybinds({
    { "n", "<leader>tn", function() typst.next_page() end, },
    { "n", "<leader>te", function() typst.prev_page() end, },
    { "n", "<leader>tgg", function() typst.first_page() end, },
    { "n", "<leader>tG", function() typst.last_page() end, },
    { "n", "<leader>td", function() typst.stop() end, },
    { "n", "<leader>to", function() typst.start() end, },
    { "n", "<leader>tr", function() typst.refresh() end, },
})

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim.git",
    { src = "https://github.com/ThePrimeagen/harpoon.git", version = "harpoon2" },
})
local harpoon = require("harpoon")
harpoon:setup()
-- stylua: ignore
utils.add_keybinds({
    {"n", "<leader>a", function() harpoon:list():add() end},
    {"n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end},
    {"n", "<leader>mn", function() harpoon:list():prev() end},
    {"n", "<leader>mp", function() harpoon:list():next() end},
})
-- stylua: ignore
for i = 1, 9 do
    utils.add_keybinds({
        {"n", "<leader>" .. i, function() harpoon:list():select(i) end},
    })
end

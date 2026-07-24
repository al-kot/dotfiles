local utils = require("utils")

vim.pack.add({
    "https://github.com/tpope/vim-dadbod.git",
    "https://github.com/kristijanhusak/vim-dadbod-ui.git",
    "https://github.com/kristijanhusak/vim-dadbod-completion.git",
})
vim.pack.add({
    "https://github.com/ellisonleao/gruvbox.nvim.git",
    "https://github.com/AlexvZyl/nordic.nvim.git",
    "https://github.com/neanias/everforest-nvim.git",
    "https://github.com/rebelot/kanagawa.nvim.git",

    "https://github.com/stevearc/oil.nvim.git",
    "https://github.com/numToStr/Comment.nvim.git",
    "https://github.com/folke/snacks.nvim.git",
    "https://codeberg.org/andyg/leap.nvim",
    "https://github.com/mrjones2014/smart-splits.nvim.git",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter.git", version = "main" },
    -- "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git",
    "https://github.com/rafamadriz/friendly-snippets.git",
    { src = "https://github.com/Saghen/blink.cmp.git", version = vim.version.range("1.*") },
    "https://github.com/stevearc/conform.nvim.git",
    "https://github.com/ggml-org/llama.vim.git",
})

-- llama.vim configuration
vim.g.llama_config = {
    show_info = false,
    -- FIM (Fill-in-the-Middle) settings
    auto_fim = true,
    keymap_fim_trigger = "<C-f>",
    keymap_fim_accept_full = "<Tab>",
    keymap_fim_accept_line = "<S-Tab>",
    keymap_fim_accept_word = "<C-w>",

    -- Instruction mode settings
    keymap_inst_trigger = "<leader>li",
    keymap_inst_retry = "<leader>lr",
    keymap_inst_continue = "<leader>lc",
    keymap_inst_accept = "<Tab>",
    keymap_inst_cancel = "<Esc>",

    -- API endpoints
    -- endpoint_fim = "http://192.168.1.249:9898/infill",
    endpoint_fim = "http://127.0.0.1:9896/infill",
    -- endpoint_inst = "http://192.168.1.249:9898/v1/chat/completions",
    endpoint_inst = "https://openrouter.ai/api/v1/chat/completions",

    -- Models
    model_fim = "qwen2.5:7b:Q6_K",
    -- model_inst = "ornith:35b:Q6_K",
    model_inst = "deepseek/deepseek-v4-flash",
    api_key = os.getenv('OR_API_KEY')
    -- deepseek/deepseek-v4-flash
}
utils.add_keybinds({
    { "n", "<leader>lf", ":silent LlamaToggleAutoFim<CR>:set statusline=%!v:lua.statusline()<CR>", { silent = true } },
})

		-- vim.api.nvim_set_hl(0, "llama_hl_fim_hint", {fg = "#f8732e", ctermfg=209})
		-- vim.api.nvim_set_hl(0, "llama_hl_fim_info", {fg = "#50fa7b", ctermfg=119})
        --llama_hl_inst_src guibg=#554433 ctermbg=236

 -- " virtual text colors for instructions
 -- highlight default llama_hl_inst_virt_proc  guifg=#77ff2f ctermfg=119
 -- highlight default llama_hl_inst_virt_gen   guifg=#77ff2f ctermfg=119
 -- highlight default llama_hl_inst_virt_ready
-- Llama.vim highlight groups
utils.set_hl({
    { "llama_hl_fim_hint", { fg = "#737c73" } },       -- FIM hint text color
    { "llama_hl_fim_info", { fg = "#737c73" } },       -- FIM info text color
    { "llama_hl_inst_src", { bg="#223249" } },          -- Instruction source background
    { "llama_hl_inst_virt_proc", { fg = "#737c73" } },  -- Virtual text for processing instructions
    { "llama_hl_inst_virt_gen", { fg = "#737c73" } },   -- Virtual text for generated instructions
    { "llama_hl_inst_virt_ready", { fg = "#737c73" } }, -- Virtual text for ready instructions
})


-- vim.pack.add({ "https://github.com/al-kot/typst-preview.nvim.git" })
vim.pack.add({ "https://github.com/ruizlenato/typst-preview.nvim.git" })
local typst = require("typst-preview")
typst.setup({
    preview = {
        position = "right",
        ppi = 144,
        max_width = 80,
        backend = "kitty",
    },
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

-- require("gruvbox").setup({
--     transparent_mode = true,
--     italic = {
--         strings = false,
--         emphasis = false,
--         comments = false,
--         operators = false,
--         folds = false,
--     },
-- })
-- require('nordic').setup({
--     transparent = {
--         bg = true,
--         float = true
--     },
--     italic_comments = false,
-- })
-- require("nordic").load()
-- require('everforest').setup({
--     transparent_background_level = 2,
--     italics = false,
--     disable_italic_comments = true,
-- })
-- require("everforest").load()
--
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
        }
    end,
})
vim.cmd("colorscheme kanagawa-dragon")
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
})

-- require("leap").set_default_mappings()
require("leap").opts.labels = "nehmluyotsrvcdpfwNEIMHLUYOTSRVCPFWDA"
require("leap").opts.safe_labels = "nehmluotsdfw"
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
vim.keymap.set("n", "gs", "<Plug>(leap-from-window)")

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

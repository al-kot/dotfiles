local utils = require("utils")

vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets.git",
})

vim.pack.add({
    "https://github.com/ggml-org/llama.vim.git",
})
vim.g.llama_config = {
    show_info = false,
    auto_fim = true,
    keymap_fim_trigger = "<C-f>",
    keymap_fim_accept_full = "<Tab>",
    keymap_fim_accept_line = "<S-Tab>",
    keymap_fim_accept_word = "<C-w>",

    keymap_inst_trigger = "<leader>li",
    keymap_inst_retry = "<leader>lr",
    keymap_inst_continue = "<leader>lc",
    keymap_inst_accept = "<Tab>",
    keymap_inst_cancel = "<Esc>",

    -- API endpoints
    endpoint_fim = "http://192.168.1.250:9898/infill",
    -- endpoint_fim = "http://127.0.0.1:9896/infill",
    endpoint_inst = "http://192.168.1.250:9898/v1/chat/completions",
    -- endpoint_inst = "https://openrouter.ai/api/v1/chat/completions",

    -- Models
    model_fim = "qwen2.5:7b:Q6_K",
    model_inst = "ornith:35b:Q6_K",
    -- model_inst = "deepseek/deepseek-v4-flash",
    api_key = os.getenv("OR_API_KEY"),
    -- deepseek/deepseek-v4-flash
}
utils.add_keybinds({
    { "n", "<leader>lf", ":silent LlamaToggleAutoFim<CR>:set statusline=%!v:lua.statusline()<CR>", { silent = true } },
})
utils.set_hl({
    { "llama_hl_fim_hint", { fg = "#737c73" } }, -- FIM hint text color
    { "llama_hl_fim_info", { fg = "#737c73" } }, -- FIM info text color
    { "llama_hl_inst_src", { bg = "#223249" } }, -- Instruction source background
    { "llama_hl_inst_virt_proc", { fg = "#737c73" } }, -- Virtual text for processing instructions
    { "llama_hl_inst_virt_gen", { fg = "#737c73" } }, -- Virtual text for generated instructions
    { "llama_hl_inst_virt_ready", { fg = "#737c73" } }, -- Virtual text for ready instructions
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

vim.pack.add({ "https://github.com/al-kot/monoglow.nvim.git" })

require("monoglow").setup({
    transparent = true,
    italic = false,
    on_colors = function(colors)
        colors.glow = "#98BB6C"
        colors.blue1 = "#76946A"
        colors.blue2 = "#76946A"
        colors.syntax = {
            string = "#727169",
        }
        colors.light_red = "#663333"
        colors.git.delete = "#663333"
        colors.git.add = "#76946A"
    end,
    on_highlights = function(highlights, colors)
        -- remove background from inline diagnostic virtual text
        highlights.DiagnosticVirtualTextError = { fg = colors.error }
        highlights.DiagnosticVirtualTextWarn = { fg = colors.warning }
        highlights.DiagnosticVirtualTextHint = { fg = colors.hint }
        highlights.DiagnosticVirtualTextInfo = { fg = colors.info }
        highlights.DiagnosticVirtualTextOk = { fg = colors.ok }
    end,
})

vim.cmd("colorscheme monoglow")

vim.pack.add({
    "https://github.com/stevearc/oil.nvim.git",
})
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
    { "n", "<leader>b", Snacks.picker.buffers },
    { "n", "<leader>n", Snacks.picker.lines },
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

vim.pack.add({
    "https://github.com/numToStr/Comment.nvim.git",
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
    "https://github.com/lewis6991/gitsigns.nvim.git",
})
local git = require("gitsigns")
git.setup({
    on_attach = function(bufnr)
        utils.add_keybinds({
            {
                "n",
                "]c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        git.nav_hunk("next")
                    end
                end,
            },
            {
                "n",
                "[c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        git.nav_hunk("prev")
                    end
                end,
            },
            { "n", "<leader>hs", git.stage_hunk },
            { "n", "<leader>hr", git.reset_hunk },

            {
                "v",
                "<leader>hs",
                function()
                    git.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end,
            },

            {
                "v",
                "<leader>hr",
                function()
                    git.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end,
            },

            { "n", "<leader>hS", git.stage_buffer },
            { "n", "<leader>hR", git.reset_buffer },
            { "n", "<leader>hp", git.preview_hunk },
            { "n", "<leader>hi", git.preview_hunk_inline },

            {
                "n",
                "<leader>hb",
                function()
                    git.blame_line({ full = true })
                end,
            },

            { "n", "<leader>hd", git.diffthis },

            {
                "n",
                "<leader>hD",
                function()
                    git.diffthis("~")
                end,
            },

            {
                "n",
                "<leader>hQ",
                function()
                    git.setqflist("all")
                end,
            },
            { "n", "<leader>hq", git.setqflist },

            -- Toggles
            { "n", "<leader>tb", git.toggle_current_line_blame },
            { "n", "<leader>tw", git.toggle_word_diff },

            -- Text object
            { { "o", "x" }, "ih", git.select_hunk },
        })
    end,
})

local vim = vim
local sethl = vim.api.nvim_set_hl

return {
    {
        "kiyoon/jupynium.nvim",
        build = "pip3 install --user .",
        -- build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
        -- build = "conda run --no-capture-output -n jupynium pip install .",
    },
    {
        'willothy/wezterm.nvim',
        config = true
    },
    {
        "GCBallesteros/jupytext.nvim",
        config = function()
            local jupy = require('jupytext')
            jupy.setup {
                style = "markdown",
                output_extension = "md",
                force_ft = "markdown",
            }
        end,
    },
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
        },
        ft = { 'quarto', 'markdown' },
        config = function()
            local quarto = require("quarto")
            quarto.setup({
                lspFeatures = {
                    -- NOTE: put whatever languages you want here:
                    languages = { "r", "python", "rust" },
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
                    -- NOTE: setup your own keymaps:
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
        end
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        config = function()
            local md = require('render-markdown')

            md.setup {
                render_modes = true,
                code = {
                    style = 'normal',
                    border = 'thick',
                },
                heading = {
                    width = 'block',
                    border = true,
                    border_virtual = true,
                    left_pad = 3,
                    right_pad = 3,
                    left_margin = 7,
                    position = 'inline',
                    icons = false,
                    min_width = 30,
                },
            }

            sethl(0, 'RenderMarkdownCode', { bg = '#282828' })

            sethl(0, 'RenderMarkdownH1Bg', { bg = '#458588', fg = '#282828' })
            sethl(0, 'RenderMarkdownH2Bg', { bg = '#689d6a', fg = '#282828' })
            sethl(0, 'RenderMarkdownH3Bg', { bg = '#98971a', fg = '#282828' })
            sethl(0, 'RenderMarkdownH4Bg', { bg = '#b16286', fg = '#282828' })
            sethl(0, 'RenderMarkdownH5Bg', { bg = '#458588', fg = '#282828' })
            sethl(0, 'RenderMarkdownH6Bg', { bg = '#689d6a', fg = '#282828' })
        end
    },
    {
        "folke/snacks.nvim",
        opts = {
            image = {
                enabled = true,
                doc = {
                    enabled = true,
                    inline = false,
                    max_width = 150,
                    max_height = 150,
                },
            },
            math = {
                enabled = true,
            },
        },
    },
    {
        "aleshasuqa/molten-nvim",
        dependencies = {
            "folke/snacks.nvim",
            'willothy/wezterm.nvim',
            "GCBallesteros/jupytext.nvim",
            "quarto-dev/quarto-nvim",
            'MeanderingProgrammer/render-markdown.nvim',
        },
        build = ":UpdateRemotePlugins",
        init = function()
            local gs = {
                molten_image_provider = "snacks.nvim",
                molten_wrap_output = true,
                molten_virt_text_max_lines = 999,
                molten_virt_text_output = true,
                molten_output_virt_lines = false,
                molten_virt_lines_off_by_1 = true,
                molten_auto_open_output = false,
                molten_output_win_hide_on_leave = false,

            }
            for key, value in pairs(gs) do
                vim.g[key] = value
            end

            vim.api.nvim_set_hl(0, 'MoltenCell', { bg = 'NONE' })
        end,
    },
}

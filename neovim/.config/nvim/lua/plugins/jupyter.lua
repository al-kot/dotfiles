local vim = vim
local sethl = vim.api.nvim_set_hl

return {
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
        "3rd/image.nvim",
        enabled = true,
        build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
        config = function()
            local image = require('image')
            image.setup {
                processor = "magick_cli",
                backend = "kitty",          -- Kitty will provide the best experience, but you need a compatible terminal
                integrations = {},          -- do whatever you want with image.nvim's integrations
                max_width = 200,            -- tweak to preference
                max_height = 200,            -- ^
                max_height_window_percentage = math.huge, -- this is necessary for a good experience
                max_width_window_percentage = math.huge,
                window_overlap_clear_enabled = true,
                window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            }
        end
    },
    {
        "benlubas/molten-nvim",
        dependencies = {
            -- 'willothy/wezterm.nvim',
            "3rd/image.nvim",
            "GCBallesteros/jupytext.nvim",
            "quarto-dev/quarto-nvim",
            'MeanderingProgrammer/render-markdown.nvim',
        },
        build = ":UpdateRemotePlugins",
        init = function()
            local gs = {
                python3_host_prog = vim.fn.expand("~/.virtualenvs/nvim/bin/python3"),
                molten_image_provider = "image.nvim",
                molten_wrap_output = true,
                molten_output_virt_lines = true,
                molten_virt_lines_off_by_1 = true,
                molten_auto_open_output = true,
                molten_output_win_hide_on_leave = false,

            }
            for key, value in pairs(gs) do
                vim.g[key] = value
            end

            vim.api.nvim_set_hl(0, 'MoltenCell', { bg = 'NONE' })
        end,
    },
}

return {
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },

        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = 'default' },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = {
                menu = { border = 'rounded', winhighlight = 'Pmenu:BlinkCmpMenu' },
                documentation = { auto_show = true,  window = { border = 'rounded' } }
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            cmdline = {
                enabled = true,
            },

            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    }
}

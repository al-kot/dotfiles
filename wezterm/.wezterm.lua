local wezterm = require('wezterm')

local config = wezterm.config_builder()

config = {
    font = wezterm.font('Mononoki Nerd Font Mono', { italic = false }),
    color_scheme = 'Gruvbox dark, hard (base16)',
    window_background_opacity = 0.70,
    macos_window_background_blur = 25,
    window_decorations = 'RESIZE',
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    show_new_tab_button_in_tab_bar = false,
    window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 0,
    },
    colors = {
        tab_bar = {
            background = 'rgba(0,0,0,0)',
            active_tab = {
                bg_color = '#83a598',
                fg_color = '#282828',
            },
            inactive_tab = {
                bg_color = 'rgba(0,0,0,0)',
                fg_color = '#ebdbb2',
            },
        }
    },
}


require('keymaps').apply_to_config(config)
require('plugins').apply_to_config(config)
require('events')

return config

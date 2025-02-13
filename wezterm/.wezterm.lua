local wezterm = require('wezterm')

local config = wezterm.config_builder()

config = {
    font = wezterm.font('Mononoki Nerd Font Mono'),
    -- colors = rosepine.colors(), -- wezterm.color.load_base16_scheme(os.getenv('HOME') .. '/.config/colors/wezterm.yaml'),
    color_scheme = 'Gruvbox dark, hard (base16)',
    window_background_opacity = 0.95,
    window_decorations = 'RESIZE',
    enable_tab_bar = false,
    window_padding = {
        left = 40,
        right = 40,
        top = 40,
        bottom = 20,
    },
    default_prog = { 'zsh' },
}

return config

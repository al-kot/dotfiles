local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config = {
    font = wezterm.font('Mononoki Nerd Font Mono'),
    colors = wezterm.color.load_base16_scheme(os.getenv('HOME') .. '/.config/colors/wezterm.yaml'),
    window_background_opacity = 0.7,
    enable_tab_bar = false,
    window_padding = {
        left = 20,
        right = 20,
        top = 20,
        bottom = 15,
    },
}

return config

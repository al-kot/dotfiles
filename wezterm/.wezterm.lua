local wezterm = require('wezterm')

local config = wezterm.config_builder()

config = {
    font = wezterm.font('Mononoki Nerd Font Mono', { italic = false }),
    color_scheme = 'Gruvbox dark, hard (base16)',
    warn_about_missing_glyphs = false,
    -- term = 'wezterm',
    enable_kitty_graphics = true,
    window_background_opacity = 0.70,
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    show_new_tab_button_in_tab_bar = false,
    window_padding = {
        left = 30,
        right = 30,
        top = 30,
        bottom = 0,
    },
    colors = {
        background = '#181818',
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

if wezterm.target_triple == 'aarch64-apple-darwin' then
    config.macos_window_background_blur = 25
    config.window_decorations = 'RESIZE'
    config.send_composed_key_when_right_alt_is_pressed = false
    config.use_ime = false
end

require('keymaps').apply_to_config(config)
require('plugins').apply_to_config(config)
require('events')

return config

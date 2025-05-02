local wezterm = require('wezterm')

local act = wezterm.action

wezterm.on('update-status', function(window, pane)
    local workspace = wezterm.mux.get_active_workspace() or "default"
    local color = {
        fg = '#8ec07c',
        bg = 'rgba(0,0,0,0)',
    }
    if window:leader_is_active() then
        color = {
            fg = '#282828',
            bg = '#8ec07c',
        }
    end
    window:set_right_status(wezterm.format {
        { Foreground = { Color = color.fg } },
        { Background = { Color = color.bg } },
        { Text = ' [' .. workspace .. '] ' },
    })
end)

local config = wezterm.config_builder()

config = {
    font = wezterm.font('Mononoki Nerd Font Mono', { italic = false }),
    color_scheme = 'Gruvbox dark, hard (base16)',
    window_background_opacity = 0.70,
    enable_tab_bar = true,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    show_new_tab_button_in_tab_bar = false,
    window_padding = {
        left = 10,
        right = 10,
        top = 10,
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
    leader = {
        mods = 'CTRL',
        key = 'b',
    },
    keys = {
        {
            mods   = 'LEADER',
            key    = 's',
            action = act.ShowLauncherArgs {
                flags = 'FUZZY|WORKSPACES',
            },
        },
        {
            mods   = 'LEADER',
            key    = 'c',
            action = act.SpawnTab('CurrentPaneDomain'),
        },
        {
            mods   = 'LEADER',
            key    = 'n',
            action = act.PromptInputLine {
                description = wezterm.format {
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Fuchsia' } },
                    { Text = 'new workspace' },
                },
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        window:perform_action(
                            act.SwitchToWorkspace {
                                name = line,
                            },
                            pane
                        )
                    end
                end),
            }
        },
        {
            mods   = "LEADER",
            key    = "v",
            action = act.SplitVertical { domain = 'CurrentPaneDomain' }
        },
        {
            mods   = "LEADER",
            key    = "h",
            action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
        },
        {
            mods   = 'CTRL',
            key    = 'h',
            action = act.ActivatePaneDirection 'Left',
        },
        {
            mods   = 'CTRL',
            key    = 'i',
            action = act.ActivatePaneDirection 'Right',
        },
        {
            mods   = 'CTRL',
            key    = 'e',
            action = act.ActivatePaneDirection 'Up',
        },
        {
            mods   = 'CTRL',
            key    = 'n',
            action = act.ActivatePaneDirection 'Down',
        },
        {
            mods   = 'LEADER',
            key    = 'f',
            action = act.TogglePaneZoomState,
        },
        {
            mods   = 'LEADER',
            key    = 'x',
            action = wezterm.action.CloseCurrentPane { confirm = false },
        },
    }
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL',
        action = act.ActivateTab(i - 1),
    })
end

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
smart_splits.apply_to_config(config, {
    direction_keys = { 'h', 'n', 'e', 'i' },
    modifiers = {
        move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
        resize = 'SHIFT|CTRL', -- modifier to use for pane resize, e.g. META+h to resize to the left
    },
})

return config

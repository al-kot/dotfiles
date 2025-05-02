local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('user-var-changed', function(window, pane, name, value)
    wezterm.log_info('var', name, value)
    if name == 'workspace' then
        window:perform_action(
            act.SwitchToWorkspace {
                name = value,
            },
            pane
        )
    end
end)

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

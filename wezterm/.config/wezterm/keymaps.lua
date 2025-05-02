local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

local function map(mods, key, action)
    return {
        mods = mods,
        key = key,
        action = action
    }
end

function M.apply_to_config(config)
    config.leader = map('CTRL', 'b')
    config.keys = {
        map("CMD", "r", act.ReloadConfiguration),
        map('LEADER', 'n', act.PromptInputLine {
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
        }),
        map('CTRL', 'L', wezterm.action.ShowDebugOverlay),
        map("LEADER", "v", act.SplitVertical { domain = 'CurrentPaneDomain' }),
        map("LEADER", "h", act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
        map('CTRL', 'h', act.ActivatePaneDirection 'Left'),
        map('CTRL', 'i', act.ActivatePaneDirection 'Right'),
        map('CTRL', 'e', act.ActivatePaneDirection 'Up'),
        map('CTRL', 'n', act.ActivatePaneDirection 'Down'),
        map('LEADER', 'c', act.SpawnTab('CurrentPaneDomain')),
        map('LEADER', 'f', act.TogglePaneZoomState),
        map('LEADER', 'x', wezterm.action.CloseCurrentPane { confirm = false }),
        map('LEADER', 's', wezterm.action_callback(function(win, pane)
            local workspaces = wezterm.mux.get_workspace_names()
            local active = wezterm.mux.get_active_workspace()
            win:perform_action(wezterm.action.SplitPane({
                    direction = 'Left',
                    size = { Percent = 8 },
                    command = {
                        args = {
                            'zsh',
                            '-lc',
                            'printf "\\033]1337;SetUserVar=%s=%s\\007" workspace `echo -n "$(echo -e "' ..
                            table.concat(workspaces, '\n') .. '" | fzf --reverse || echo ' .. active .. ')" | base64` ; sleep 0.01'
                        }
                    },
                }),
                pane)
        end)),
    }

    for i = 1, 9 do
        table.insert(config.keys, map('CTRL', tostring(i), act.ActivateTab(i - 1)))
    end
end

return M

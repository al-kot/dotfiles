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
    config.leader = map('CTRL', 't')
    config.keys = {
        map("SUPER", "r", act.ReloadConfiguration),
        map('SUPER', 'n', act.PromptInputLine {
            description = '',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                            spawn = {
                                cwd = '~',
                            },
                        },
                        pane
                    )
                end
            end),
        }),
        map('LEADER', 'd', wezterm.action.ShowDebugOverlay),
        map("LEADER", "v", act.SplitVertical { domain = 'CurrentPaneDomain' }),
        map("LEADER", "h", act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
        map('LEADER', 'c', act.ActivateCopyMode),

        map('CTRL', 'h', act.ActivatePaneDirection 'Left'),
        map('CTRL', 'l', act.ActivatePaneDirection 'Right'),
        map('CTRL', 'k', act.ActivatePaneDirection 'Up'),
        map('CTRL', 'j', act.ActivatePaneDirection 'Down'),
        map('CTRL|SHIFT', 'h', act.AdjustPaneSize { 'Left', 5 }),
        map('CTRL|SHIFT', 'l', act.AdjustPaneSize { 'Right', 5 }),
        map('CTRL|SHIFT', 'k', act.AdjustPaneSize { 'Up', 5 }),
        map('CTRL|SHIFT', 'j', act.AdjustPaneSize { 'Down', 5 }),

        map('SUPER', 'm', act.TogglePaneZoomState),
        map('SUPER', 'x', act.CloseCurrentPane { confirm = false }),
        map('SUPER', 's', wezterm.action_callback(function(win, pane)
            local workspaces = wezterm.mux.get_workspace_names()
            local choices = {}
            for _, w in ipairs(workspaces) do
                table.insert(choices, { label = w })
            end

            win:perform_action(
                act.InputSelector {
                    action = wezterm.action_callback(
                        function(inner_window, inner_pane, id, label)
                            if not id and not label then
                                wezterm.log_info 'cancelled'
                            else
                                inner_window:perform_action(
                                    act.SwitchToWorkspace {
                                        name = label,
                                    },
                                    inner_pane
                                )
                            end
                        end
                    ),
                    title = '',
                    choices = choices,
                    fuzzy = true,
                    fuzzy_description = '',
                },
                pane
            )

        end)),
        map('SUPER', 'u', act.ScrollByPage(-0.5)),
        map('SUPER', 'd', act.ScrollByPage(0.5)),
    }
end

return M

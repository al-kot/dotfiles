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
        map('CTRL', 'L', wezterm.action.ShowDebugOverlay),
        map("SUPER", "-", act.SplitVertical { domain = 'CurrentPaneDomain' }),
        map("SUPER", "|", act.SplitHorizontal { domain = 'CurrentPaneDomain' }),
        map('CTRL|SHIFT', 'c', act.ActivateCopyMode),

        map('ALT', 'h', act.ActivatePaneDirection 'Left'),
        map('ALT', 'l', act.ActivatePaneDirection 'Right'),
        map('ALT', 'k', act.ActivatePaneDirection 'Up'),
        map('ALT', 'j', act.ActivatePaneDirection 'Down'),
        map('CTRL', 'h', act.AdjustPaneSize { 'Left', 5 }),
        map('CTRL', 'l', act.AdjustPaneSize { 'Right', 5 }),
        map('CTRL', 'k', act.AdjustPaneSize { 'Up', 5 }),
        map('CTRL', 'j', act.AdjustPaneSize { 'Down', 5 }),

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

local wezterm = require 'wezterm'
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

local M = {}

function M.apply_to_config(config)
    smart_splits.apply_to_config(config, {
        direction_keys = { 'h', 'j', 'k', 'l' },
        modifiers = {
            move = 'CTRL',     -- modifier to use for pane movement, e.g. CTRL+h to move left
            resize = 'CTRL|SHIFT', -- modifier to use for pane resize, e.g. META+h to resize to the left
        },
    })
end

return M

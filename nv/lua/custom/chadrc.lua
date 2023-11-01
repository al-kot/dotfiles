---@type ChadrcConfig



local M = {}

M.ui = {
    theme = 'tokyonight',
    hl_override = {
        Pmenu = { bg = "NONE" },
        Normal = { bg = "NONE" },
        NormalFloat = { bg = "NONE" }
    },
    statusline = {
        theme = "minimal",
        separator_style = "arrow",
    },
}
M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M

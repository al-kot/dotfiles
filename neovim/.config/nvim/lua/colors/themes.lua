local theme = require("kanagawa.colors").setup({ theme = "wave" }).theme

local kanagawa = {}

kanagawa.normal = {
    a = { bg = "none", fg = theme.syn.type },
    b = { bg = "none", fg = theme.syn.fun },
    c = { bg = "none", fg = theme.ui.fg },
}

kanagawa.insert = {
    a = { bg = "none", fg = theme.diag.ok },
    b = { bg = "none", fg = theme.syn.fun },
}

kanagawa.command = {
    a = { bg = "none", fg = theme.ui.bg },
    b = { bg = "none", fg = theme.syn.operator },
}

kanagawa.visual = {
    a = { bg = "none", fg = theme.syn.special3 },
    b = { bg = "none", fg = theme.syn.keyword },
}

kanagawa.replace = {
    a = { bg = "none", fg = theme.ui.bg },
    b = { bg = "none", fg = theme.syn.constant },
}

kanagawa.inactive = {
    a = { bg = "none", fg = theme.ui.fg_dim },
    b = { bg = "none", gui = "bold" },
    c = { bg = "none", fg = theme.ui.fg_dim },
}

if vim.g.kanagawa_lualine_bold then
    for _, mode in pairs(kanagawa) do
        mode.a.gui = "bold"
    end
end

return kanagawa

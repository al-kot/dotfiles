local plugins = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "nvim-pack/nvim-spectre",
    "dstein64/vim-startuptime",
}

To_disbable = {}

for _, p in ipairs(plugins) do
    table.insert(To_disbable, { p, enabled = false })
end

return {
    To_disbable
}

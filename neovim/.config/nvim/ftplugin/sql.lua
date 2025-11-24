vim.pack.add({
    "https://github.com/tpope/vim-dadbod.git",
    "https://github.com/kristijanhusak/vim-dadbod-ui.git",
    "https://github.com/kristijanhusak/vim-dadbod-completion.git"
})

vim.lsp.config["postgres_lsp"] = {
    cmd = { "postgres-language-server", "lsp-proxy" },
    filetypes = {
        "sql",
    },
    root_markers = { "postgres-language-server.jsonc" },
}
-- vim.schedule(function()
--     vim.lsp.enable("postgres_lsp")
-- end)

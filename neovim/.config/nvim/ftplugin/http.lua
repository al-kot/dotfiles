vim.pack.add({
    "https://github.com/mistweaverco/kulala.nvim.git",
    "https://github.com/stevearc/conform.nvim.git",
})

require("kulala").setup({
    global_keymaps = true,
    global_keymaps_prefix = "<leader>r",
    ui = {
        default_view = "body",
        show_request_summary = false,
        winbar = false,
    },
})

vim.lsp.config["kulala_ls"] = {
    cmd = { "kulala-ls", "--stdio" },
    filetypes = { "http" },
    root_markers = { ".git" },
}
vim.lsp.enable('kulala_ls')

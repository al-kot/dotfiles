local utils = require("utils")
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "html",
        "css",
        "rust",
        "python",
        "latex",
        "http",
    },
    callback = function()
        vim.treesitter.start()
    end,
})

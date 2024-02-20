-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.c", "*.h", "*.cpp", "*.lua", "*.py" },
    desc = "Auto-format c files after saving",
    callback = function()
        vim.cmd(":silent LspZeroFormat")
    end,
    group = autocmd_group,
})

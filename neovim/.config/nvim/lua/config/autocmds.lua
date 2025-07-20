-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local vim = vim

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = "*/waybar/*",
    callback = function()
        vim.cmd("silent exec \"!killall -SIGUSR2 waybar\"")
    end
})

local imb = function()
    vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        if vim.tbl_contains(kernels, 'venv') then
            vim.cmd('MoltenInit venv')
            vim.cmd("MoltenImportOutput")
        end
    end)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.ipynb",
    callback = function()
        require('quarto').activate()
        if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            imb()
        end
    end
})

-- automatically import output chunks from a jupyter notebook
vim.api.nvim_create_autocmd("BufAdd", {
    pattern = { "*.ipynb" },
    callback = imb,
})

-- automatically export output chunks to a jupyter notebook on write
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.ipynb" },
    callback = function()
        if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
        end
    end,
})

-- vim.api.nvim_create_autocmd("VimLeave", {
--     pattern = { "*" },
--     callback = function ()
--         vim.cmd("!reset_cursor.sh")
--     end
-- })

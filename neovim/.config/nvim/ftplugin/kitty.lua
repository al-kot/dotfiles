vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        vim.cmd([[silent !kill -SIGUSR1 $(pgrep -a kitty)]])
    end,
})


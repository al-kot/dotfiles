vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    callback = function()
        vim.cmd([[:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50]])
        -- print('hello')
    end,
})
vim.keymap.set(
    "n",
    "<C-z>",
    ":set guicursor=a:ver25<CR><C-z>:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50<CR>"
)
vim.api.nvim_create_autocmd({ "VimLeave" }, {
    callback = function()
        vim.cmd([[:set guicursor=a:ver25]])
        -- print('hello')
    end,
})

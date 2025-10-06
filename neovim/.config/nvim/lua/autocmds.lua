local utils = require("utils")
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

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.ipynb",
    callback = function()
        local ju_file = vim.fn.expand("%:r") .. ".ju.py"
        local cmd = { "ipynb2jupytext", vim.fn.expand("%p"), ju_file }
        vim.system(cmd, function(obj)
            if obj.code == 0 then
                vim.schedule(function()
                    vim.cmd("e " .. ju_file)
                end)
            else
                print("conversion failed")
            end
        end)
    end,
})
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*.ju.py",
    callback = function()
        vim.system({ "mv", vim.fn.expand("%p"), "/tmp/ju.py.bck" })
    end,
})

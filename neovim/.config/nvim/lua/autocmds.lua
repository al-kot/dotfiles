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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opt = { buffer = ev.buf }
        utils.add_keybinds({
            { "n", "gD", vim.lsp.buf.declaration, opt },
            {
                "n",
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                opt,
            },
            { "n", "E", vim.lsp.buf.hover, opt },
            {
                "n",
                "gi",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                opt,
            },
            { { "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, opt },
            { "n", "<leader>D", vim.lsp.buf.type_definition, opt },
            -- { "n", "<leader>rn", vim.lsp.buf.rename, opt },
            -- { 'n',          '<leader>f',  vim.lsp.buf.format,                                 opt },
            { { "n", "v" }, "<space>va", vim.lsp.buf.code_action, opt },
            {
                "n",
                "gr",
                function()
                    Snacks.picker.lsp_references()
                end,
                opt,
            },
        })
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

local utils = require("utils")

vim.pack.add({ "https://github.com/al-kot/typst-preview.nvim.git" })
local typst = require("typst-preview")
typst.setup({
    preview = {
        position = "right",
        ppi = 144,
        max_width = 80,
    },
})

-- stylua: ignore
local keymaps = {
    { "n", "<leader>tn",  function() typst.next_page() end, },
    { "n", "<leader>te",  function() typst.prev_page() end, },
    { "n", "<leader>tgg", function() typst.first_page() end, },
    { "n", "<leader>tG",  function() typst.last_page() end, },
    { "n", "<leader>td",  function() typst.stop() end, },
    { "n", "<leader>to",  function() typst.start() end, },
    { "n", "<leader>tr",  function() typst.refresh() end, },
}

utils.add_keybinds(keymaps)
vim.opt.spell = true
vim.opt.spelllang = "en,fr"
require("typst-preview").start()

vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
}
vim.lsp.enable("tinymist")

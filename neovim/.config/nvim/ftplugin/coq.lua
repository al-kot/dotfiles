local utils = require("utils")
print('hello')

utils.del_keybinds({
    { "n", "<leader>c" },
})
vim.pack.add({
    "https://github.com/whonore/Coqtail.git",
})

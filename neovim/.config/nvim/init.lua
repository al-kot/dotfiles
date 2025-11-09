local utils = require("utils")

local gs = {
    mapleader = " ",
    -- python3_host_prog = io.popen("which python3"):read("*a"):gsub("[\n\r]", ""),
}
utils.fill_table(vim.g, gs)

local opts = {
    number = true,
    relativenumber = true,
    tabstop = 4,
    shiftwidth = 4,
    swapfile = false,
    mouse = "a",
    expandtab = true,
    autoindent = true,
    background = "dark",
    cursorline = true,
    wrap = false,
    signcolumn = "yes",
    winborder = "rounded",
    pumblend = 10,
    autoread = true,
    completeopt = "noselect,menuone,popup,fuzzy,preview",
    termguicolors = true,
    undofile = true,
    splitright = true,
    showmode = false,
}
utils.fill_table(vim.o, opts)
vim.opt.path:append("**")
vim.opt.fillchars = { eob = " " }
vim.opt.clipboard:append("unnamedplus")

utils.add_keybinds({
    { "n", "<leader>o", ":update<CR>:so<CR>", { silent = true } },
    { "v", "N", ":m '>+1<CR>gv=gv" },
    { "v", "E", ":m '<-2<CR>gv=gv" },
    { "n", "<C-d>", "<C-d>zz" },
    { "n", "<C-u>", "<C-u>zz" },
    { "x", "p", '"_dP' },
    { "i", "<C-c>", "<Esc>" },
    -- { "n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]] },
    { "n", "<leader>d", vim.diagnostic.open_float },
    { "n", "<leader>s", "1z=" },
    { "n", "<leader>qn", ":cnext<CR>" },
    { "n", "<leader>qp", ":cprev<CR>" },
})

vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = "",
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

require("plugins")
require("statusline")
require("autocmds")
require("autocmds")
require("commands")

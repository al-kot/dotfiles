vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.pumblend = 10
vim.opt.autoread = true
vim.opt.completeopt = "noselect,menuone,popup,fuzzy,preview"
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.cmdheight = 0

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.showmode = false

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.path:append("**")
vim.opt.fillchars = { eob = " " }
vim.opt.clipboard:append("unnamedplus")

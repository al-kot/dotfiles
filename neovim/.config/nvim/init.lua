local utils = require('utils')

local gs = {
    mapleader = ' ',
    python3_host_prog = io.popen('which python3'):read('*a'):gsub('[\n\r]', ''),
}
utils.fill_table(vim.g, gs)

local opts = {
    number = true,
    relativenumber = true,
    tabstop = 4,
    shiftwidth = 4,
    swapfile = false,
    mouse = 'a',
    expandtab = true,
    autoindent = true,
    background = 'dark',
    cursorline = true,
    wrap = false,
    signcolumn = 'yes',
    winborder = 'rounded',
    pumblend = 10,
    autoread = true,
    completeopt = 'noselect,menuone,popup,fuzzy,preview',
    termguicolors = true,
    undofile = true,
}
utils.fill_table(vim.o, opts)
vim.opt.path:append('**')
vim.opt.clipboard:append('unnamedplus')

utils.add_keybinds({
    { 'n', '<leader>o', ':update<CR>:so<CR>',                           { silent = true } },
    { "v", "N",         ":m '>+1<CR>gv=gv" },
    { "v", "E",         ":m '<-2<CR>gv=gv" },
    { "n", "<C-d>",     '<C-d>zz' },
    { "n", "<C-u>",     '<C-u>zz' },
    { "x", "p",         '"_dP' },
    { "i", "<C-c>",     "<Esc>" },
    { "n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]] },
    { 'n', '<leader>d', vim.diagnostic.open_float },
})


require('plugins')
require('lsp')
require('statusline')
require('autocmds')



local new_buf = -1
local img = {
    pos = { 1, 1 },
    inline = true,
    max_width = 100,  -- Specific width in characters
    max_height = 100, -- Specific height in lines
    placement = nil,
}

local function render_image(buffer, name)
    if vim.api.nvim_buf_is_valid(buffer) then
        vim.api.nvim_buf_delete(buffer, { force = true })
    end
    new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_command('rightbelow vnew')
    vim.api.nvim_win_set_buf(0, new_buf)
    buffer = new_buf
    if img.placement then
        img.placement:close()
        img.placement = nil
    end
    img.placement = Snacks.image.placement.new(buffer, name, img)
    vim.api.nvim_command('wincmd p')
end

local function compile_render(buffer, name)
    -- vim.fn.system('typst compile -f pdf /Users/alekseikotliarov/test/main.typ')
    -- if new_buf ~= -1 then
    render_image(buffer, name)
    -- end

    -- local cache_dir = vim.fn.stdpath("cache") .. "/snacks/image/"
    -- local pdf_basename = vim.fn.fnamemodify(name, ":t:r") -- Get 'main' from 'main.pdf'
    -- local cached_pattern = cache_dir .. "*" .. pdf_basename .. ".*"
    -- local cached_files = vim.fn.glob(cached_pattern, true, true)
    -- for _, cached_file in ipairs(cached_files) do
    --     if vim.fn.filereadable(cached_file) == 1 then
    --         vim.fn.delete(cached_file)
    --         vim.notify("Deleted cached PNG: " .. cached_file, vim.log.levels.INFO)
    --     end
    -- end
end

local function make_new_window()
    new_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_command('rightbelow vnew')
    vim.api.nvim_win_set_buf(0, new_buf)
    vim.api.nvim_command('wincmd p')
end

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { '*.typ' },
    callback = function()
        -- make_new_window()
    end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { '*.typ' },
    callback = function()
        compile_render(new_buf, '/Users/alekseikotliarov/test/main.typ')
    end,
})

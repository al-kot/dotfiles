local utils = require("utils")

local gs = {
    mapleader = " ",
    python3_host_prog = io.popen("which python3"):read("*a"):gsub("[\n\r]", ""),
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

vim.keymap.set("n", "<leader>bn", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1] - 1, cursor[2]

    local parser = vim.treesitter.get_parser(bufnr, "markdown")
    local tree = parser:parse()[1]
    local root = tree:root()

    local fenced_node = nil

    -- Check every fenced_code_block in the buffer
    local function contains_cursor(node)
        local start_row, start_col, end_row, end_col = node:range()
        if row < start_row or row > end_row then return false end
        if row == start_row and col < start_col then return false end
        if row == end_row and col > end_col then return false end
        return true
    end

    local function find_fenced_node(node)
        if node:type() == "fenced_code_block" and contains_cursor(node) then
            return node
        end
        for child in node:iter_children() do
            local found = find_fenced_node(child)
            if found then return found end
        end
        return nil
    end

    fenced_node = find_fenced_node(root)

    local insert_line
    if fenced_node then
        insert_line = fenced_node:end_() + 1
    else
        insert_line = row + 1
    end

    local lines = { "```python", "", "```", "" }
    local buf_line_count = vim.api.nvim_buf_line_count(bufnr)
    if insert_line > buf_line_count then
        insert_line = buf_line_count
        lines = { "", "```python", "", "```", "" }
    end
    vim.api.nvim_buf_set_lines(bufnr, insert_line, insert_line, true, lines)
    vim.api.nvim_win_set_cursor(0, { insert_line + 2, 0 })
end, { desc = "Smart insert markdown code block (Tree-sitter)" })

require("plugins")
require("lsp")
require("statusline")
require("autocmds")
require("autocmds")
require("commands")



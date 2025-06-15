local vim = vim
local map = vim.keymap.set
local del = vim.keymap.del

map('n', '<leader>h', ':noh<CR>', { silent = true })

map("v", "N", ":m '>+1<CR>gv=gv")
map("v", "E", ":m '<-2<CR>gv=gv")

map("x", "p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]])

map("n", "<leader>e", ':Oil<CR>')
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { silent = true })

map('n', '<leader>d', vim.diagnostic.open_float)

map('n', '<C-h>', require('smart-splits').move_cursor_left)
map('n', '<C-n>', require('smart-splits').move_cursor_down)
map('n', '<C-e>', require('smart-splits').move_cursor_up)
map('n', '<C-i>', require('smart-splits').move_cursor_right)
map('n', '<C-S-h>', require('smart-splits').resize_left)
map('n', '<C-S-n>', require('smart-splits').resize_down)
map('n', '<C-S-e>', require('smart-splits').resize_up)
map('n', '<C-S-i>', require('smart-splits').resize_right)

-- telescope
local telescope_builtin = require('telescope.builtin')
map('n', '<C-f>',
    function()
        telescope_builtin.find_files({
            hidden = true,
            layout_config = {
                width = 0.9,
                height = 0.9
            }
        })
    end)
map('n', '<leader>fg',
    function()
        telescope_builtin.live_grep({
            layout_strategy = 'vertical',
            layout_config = {
                mirror = true,
                preview_cutoff = 1,
                width = 0.8,
                height = 0.99
            },
            additional_args = { '--hidden' }
        })
    end)
map('n', '<leader>fh',
    function()
        telescope_builtin.help_tags({
            layout_strategy = 'vertical',
            layout_config = {
                mirror = true,
                preview_cutoff = 1,
                width = 0.5,
                height = 0.99
            }
        })
    end)
map('n', "<leader>vs",
    function()
        vim.cmd(":split<CR>")
        telescope_builtin.find_files({ hidden = true })
    end)
map('n', "<leader>hs",
    function()
        vim.cmd(":vsplit<CR>")
        telescope_builtin.find_files({ hidden = true })
    end)
map('n', '<leader>q', telescope_builtin.quickfix)

-- harpoon
local harpoon = require('harpoon')
harpoon:setup()
map('n', '<leader>a', function() harpoon:list():add() end)
map('n', '<M-T>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
map('n', '<M-t>', function() harpoon:list():select(1) end)
map('n', '<M-s>', function() harpoon:list():select(2) end)
map('n', '<M-r>', function() harpoon:list():select(3) end)

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>t", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opt = { buffer = ev.buf }
        local telescope = require('telescope.builtin')
        map('n', 'gD', vim.lsp.buf.declaration, opt)
        map('n', 'gd', function() telescope.lsp_definitions({ jump_type = "vsplit" }) end, opt)
        map('n', 'E', vim.lsp.buf.hover, opt)
        map('n', 'gi', telescope.lsp_implementations, opt)
        map({ 'n', 'i' }, '<C-s>', vim.lsp.buf.signature_help, opt)
        map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt)
        map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opt)
        map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opt)
        map('n', '<space>D', vim.lsp.buf.type_definition, opt)
        map('n', '<space>rn', vim.lsp.buf.rename, opt)
        map({ 'n', 'v' }, '<space>va', vim.lsp.buf.code_action, opt)
        map('n', 'gr', telescope.lsp_references, opt)
    end,
})

-- molten
map("n", "<leader>me", ":MoltenEvaluateOperator<CR>")
map("n", "<leader>rr", ":MoltenReevaluateCell<CR>")
map("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv")
map("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>")
map("n", "<leader>oh", ":MoltenHideOutput<CR>")
map("n", "<leader>md", ":MoltenDelete<CR>")

-- quarto
local runner = require('quarto.runner')
map("n", "<leader>r", runner.run_cell, { desc = "run cell", silent = true })
map("n", "<leader>ra", runner.run_all, { desc = "run all cells", silent = true })
map("n", "<leader>rl", runner.run_line, { desc = "run line", silent = true })
map("v", "<leader>r", runner.run_range, { desc = "run visual range", silent = true })


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

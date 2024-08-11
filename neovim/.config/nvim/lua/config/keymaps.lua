-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Colemak
--
local map = vim.keymap.set

map('', "k", "i")
map('', "j", "n")
map('', "l", "e")
map('', "J", "N")
map('', "L", "E")
map('', "K", "I")

map('', "n", "j")
map('', "e", "k")
map('', "i", "l")

map('', "N", "J")
map('', "E", "K")
map('', "I", "L")


map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<C-e>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<C-n>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<C-i>", "<cmd>TmuxNavigateRight<cr>")

map("v", "N", ":m '>+1<CR>gv=gv")
map("v", "E", ":m '<-2<CR>gv=gv")

map("n", "<C-l>", "<C-u>zz")
map("n", "<C-m>", "<C-d>zz")

map("x", "<leader>p", '"_dP')
map("i", "<C-c>", "<Esc>")
map("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

map("n", "<leader>e", vim.cmd.Ex)

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, {})
map('n', '<leader>fg', builtin.live_grep, {})
map('n', '<leader>fb', builtin.buffers, {})
map('n', '<leader>fh', builtin.help_tags, {})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        map('n', 'gD', vim.lsp.buf.declaration, opts)
        map('n', 'gd', vim.lsp.buf.definition, opts)
        map('n', 'E', vim.lsp.buf.hover, opts)
        map('n', 'gi', vim.lsp.buf.implementation, opts)
        map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        map('n', '<space>D', vim.lsp.buf.type_definition, opts)
        map('n', '<space>rn', vim.lsp.buf.rename, opts)
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        map('n', 'gr', vim.lsp.buf.references, opts)
        map('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

local harpoon = require('harpoon')
harpoon:setup()

map("n", "<leader>a", function() harpoon:list():add() end)

map("n", "<S-h>", function() harpoon:list():prev() end)
map("n", "<S-i>", function() harpoon:list():next() end)
map("n", "<leader>1", function() harpoon:list():select(1) end)
map("n", "<leader>2", function() harpoon:list():select(2) end)
map("n", "<leader>3", function() harpoon:list():select(3) end)
map("n", "<leader>4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list

map("n", "<C-u>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)


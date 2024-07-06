-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Colemak
--
local kmp = vim.keymap

kmp.set({'n', 'v'}, "n", "j")
kmp.set({'n', 'v'}, "e", "k")
kmp.set({'n', 'v'}, "i", "l")
kmp.set({'n', 'v'}, "j", "n")
kmp.set({'n', 'v'}, "k", "i")
kmp.set({'n', 'v'}, "l", "e")
kmp.set({'n', 'v'}, "N", "J")
kmp.set({'n', 'v'}, "E", "K")
kmp.set({'n', 'v'}, "I", "L")
kmp.set({'n', 'v'}, "J", "N")
kmp.set({'n', 'v'}, "K", "I")
kmp.set({'n', 'v'}, "L", "E")


kmp.del("n", "<C-h>")
kmp.del("n", "<C-j>")
kmp.del("n", "<C-k>")
kmp.del("n", "<C-l>")
kmp.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
kmp.set("n", "<C-e>", "<cmd>TmuxNavigateUp<cr>")
kmp.set("n", "<C-n>", "<cmd>TmuxNavigateDown<cr>")
kmp.set("n", "<C-i>", "<cmd>TmuxNavigateRight<cr>")

kmp.set("v", "N", ":m '>+1<CR>gv=gv")
kmp.set("v", "E", ":m '<-2<CR>gv=gv")

kmp.set("n", "<C-l>", "<C-u>zz")
kmp.set("n", "<C-m>", "<C-d>zz")

kmp.set("x", "<leader>p", '"_dP')
kmp.set("i", "<C-c>", "<Esc>")
kmp.set("n", "<leader>k", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
kmp.set("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true })

kmp.set("n", "<leader>e", vim.cmd.Ex)

local builtin = require('telescope.builtin')
kmp.set('n', '<leader>ff', builtin.find_files, {})
kmp.set('n', '<leader>fg', builtin.live_grep, {})
kmp.set('n', '<leader>fb', builtin.buffers, {})
kmp.set('n', '<leader>fh', builtin.help_tags, {})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        kmp.set('n', 'gD', vim.lsp.buf.declaration, opts)
        kmp.set('n', 'gd', vim.lsp.buf.definition, opts)
        kmp.set('n', 'K', vim.lsp.buf.hover, opts)
        kmp.set('n', 'gi', vim.lsp.buf.implementation, opts)
        kmp.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        kmp.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        kmp.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        kmp.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        kmp.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        kmp.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        kmp.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        kmp.set('n', 'gr', vim.lsp.buf.references, opts)
        kmp.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

local harpoon = require('harpoon')
harpoon:setup()

kmp.set("n", "<leader>a", function() harpoon:list():add() end)

kmp.set("n", "<S-h>", function() harpoon:list():prev() end)
kmp.set("n", "<S-l>", function() harpoon:list():next() end)
kmp.set("n", "<leader>1", function() harpoon:list():select(1) end)
kmp.set("n", "<leader>2", function() harpoon:list():select(2) end)
kmp.set("n", "<leader>3", function() harpoon:list():select(3) end)
kmp.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list

kmp.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)


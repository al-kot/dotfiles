local utils = require("utils")

vim.lsp.config["pyright"] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                    reportUnusedExpression = "none",
                },
            },
        },
    },
}
vim.schedule(function() vim.lsp.enable("pyright") end)

local keymaps = {
    {
        { "x", "o" },
        "iC",
        function()
            require("jupynium.textobj").select_cell(false, true)
        end,
    },
    {
        { "x", "o" },
        "aC",
        function()
            require("jupynium.textobj").select_cell(true, true)
        end,
    },
    {
        { "x", "o" },
        "ic",
        function()
            require("jupynium.textobj").select_cell(false, false)
        end,
    },
    {
        { "x", "o" },
        "ac",
        function()
            require("jupynium.textobj").select_cell(true, false)
        end,
    },
    {
        { "n", "x", "o" },
        "<space>jj",
        function()
            require("jupynium.textobj").goto_current_cell_separator()
        end,
    },
    {
        { "n", "x", "o" },
        ")",
        function()
            require("jupynium.textobj").goto_next_cell_separator()
        end,
    },
    {
        { "n", "x", "o" },
        "(",
        function()
            require("jupynium.textobj").goto_previous_cell_separator()
        end,
    },
    {
        "n",
        "<leader>nr",
        ":JupyniumExecuteSelectedCells<CR>:lua require('jupynium.textobj').goto_next_cell_separator()<CR>",
    },
    { "n", "<leader>r", ":JupyniumExecuteSelectedCells<CR>" },
    { "n", "<leader>na", ":JupyniumStartAndAttachToServer<CR>" },
    { "n", "<leader>ns", ":JupyniumStartSync " },
    { "n", "<leader>nc", "o<CR># %%<CR>" },
}

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.ju.py",
    callback = function()
        vim.pack.add({
            "https://github.com/kiyoon/jupynium.nvim.git",
        })
        require("jupynium").setup({
            python_host = { "uv", "run", "--with", "selenium,geckodriver,jupynium,ipykernel", "python" },
            jupyter_command = { "uv", "run", "--with", "notebook,nbclassic", "jupyter" },
            default_notebook_URL = "localhost:8888/nbclassic",
            -- firefox_profile_name = "default-release",
            -- firefox_profiles_ini_path = vim.fn.has("macunix") and "~/Library/Application Support/Firefox/profiles.ini"
                -- or "~/.mozilla/firefox/profiles.ini",
            use_default_keybindings = false,
            textobjects = {
                use_default_keybindings = false,
            },
        })
        utils.add_keybinds(keymaps)
        utils.set_hl({
            { "JupyniumMarkdownCellContent", { bg = "none" } },
        })
    end,
})


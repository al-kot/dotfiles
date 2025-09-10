local utils = require("utils")

vim.pack.add({
    "https://github.com/stevearc/conform.nvim.git",
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        c = { "clangd" },
        typst = { "typstyle" },
    },
})

utils.add_keybinds({
    {
        "n",
        "<leader>f",
        function()
            require("conform").format({ lsp_format = "fallback" })
        end,
    },
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

local servers = {
    ["luals"] = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim", "Snacks" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            },
        },
    },
    ["pyright"] = {
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
                },
            },
        },
    },
    ["clangd"] = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        root_markers = {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            ".git",
        },
        capabilities = {
            textDocument = {
                completion = {
                    editsNearCursor = true,
                },
            },
            offsetEncoding = { "utf-8", "utf-16" },
        },
    },
    ["tinymist"] = {
        cmd = { "tinymist" },
        filetypes = { "typst" },
        -- settings = {
        -- },
    },
}

for name, config in pairs(servers) do
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opt = { buffer = ev.buf }
        utils.add_keybinds({
            { "n", "gD", vim.lsp.buf.declaration, opt },
            {
                "n",
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                opt,
            },
            { "n", "E", vim.lsp.buf.hover, opt },
            {
                "n",
                "gi",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                opt,
            },
            { { "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, opt },
            { "n", "<leader>D", vim.lsp.buf.type_definition, opt },
            -- { "n", "<leader>rn", vim.lsp.buf.rename, opt },
            -- { 'n',          '<leader>f',  vim.lsp.buf.format,                                 opt },
            { { "n", "v" }, "<space>va", vim.lsp.buf.code_action, opt },
            {
                "n",
                "gr",
                function()
                    Snacks.picker.lsp_references()
                end,
                opt,
            },
        })
    end,
})

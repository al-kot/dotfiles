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
        typescript = { "prettierd", "prettier", stop_after_first = true },
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
    ["kulala_ls"] = {
        cmd = { "kulala-ls", "--stdio" },
        filetypes = { "http" },
        root_markers = { ".git" },
    },
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
                    diagnosticSeverityOverrides = {
                        reportUnusedExpression = "none",
                    },
                },
            },
        },
    },
    ["clangd"] = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose", "--enable-config" },
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
    ["ts_ls"] = {
        init_options = { hostInfo = "neovim" },
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
        root_dir = function(bufnr, on_dir)
            -- The project root is where the LSP can be started from
            -- As stated in the documentation above, this LSP supports monorepos and simple projects.
            -- We select then from the project root, which is identified by the presence of a package
            -- manager lock file.
            local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
            -- Give the root markers equal priority by wrapping them in a table
            root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
                or vim.list_extend(root_markers, { ".git" })
            -- We fallback to the current working directory if no project root is found
            local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

            on_dir(project_root)
        end,
        handlers = {
            -- handle rename request for certain code actions like extracting functions / types
            ["_typescript.rename"] = function(_, result, ctx)
                local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
                vim.lsp.util.show_document({
                    uri = result.textDocument.uri,
                    range = {
                        start = result.position,
                        ["end"] = result.position,
                    },
                }, client.offset_encoding)
                vim.lsp.buf.rename()
                return vim.NIL
            end,
        },
        commands = {
            ["editor.action.showReferences"] = function(command, ctx)
                local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
                local file_uri, position, references = unpack(command.arguments)

                local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
                vim.fn.setqflist({}, " ", {
                    title = command.title,
                    items = quickfix_items,
                    context = {
                        command = command,
                        bufnr = ctx.bufnr,
                    },
                })

                vim.lsp.util.show_document({
                    uri = file_uri,
                    range = {
                        start = position,
                        ["end"] = position,
                    },
                }, client.offset_encoding)

                vim.cmd("botright copen")
            end,
        },
        on_attach = function(client, bufnr)
            -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
            -- `vim.lsp.buf.code_action()` if specified in `context.only`.
            vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
                local source_actions = vim.tbl_filter(function(action)
                    return vim.startswith(action, "source.")
                end, client.server_capabilities.codeActionProvider.codeActionKinds)

                vim.lsp.buf.code_action({
                    context = {
                        only = source_actions,
                    },
                })
            end, {})
        end,
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

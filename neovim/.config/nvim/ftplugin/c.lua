print("hello from c")
local cmd = vim.bo.filetype == "cuda"
        and {
            "clangd",
            "--background-index",
            "--log=verbose",
            "--enable-config",
            "--query-driver=/opt/cuda/bin/nvcc",
        }
    or {
        "clangd",
        "--background-index",
        "--log=verbose",
        "--enable-config",
    }
local init_options = vim.bo.filetype == "cuda"
        and {
            "-xcuda",
            "--cuda-path=/opt/cuda",
            "--cuda-gpu-arch=sm_75",
            "-I/opt/cuda/include",
            "-I/opt/cuda/targets/x86_64-linux/include",
            "-I/opt/cuda/include/cccl",
            "--no-cuda-version-check",
            "-std=c++17",
            "-D__CUDACC__",
            "-Wno-unknown-cuda-version",
        }
    or {}

vim.lsp.config["clangd"] = {
    cmd = cmd,
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
    init_options = init_options,
}
vim.lsp.enable("clangd")

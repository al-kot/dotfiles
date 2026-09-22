vim.lsp.config['zls'] = {
    cmd = { 'zls' },
    filetypes = { 'zig' },
    root_markers = { 'zls.json', 'build.zig', '.git' }
}
vim.lsp.inlay_hint.enable()
vim.lsp.enable('zls')

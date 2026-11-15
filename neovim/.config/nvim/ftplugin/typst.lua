vim.opt.spell = true
vim.opt.spelllang = "en,fr"

-- local utils = require("utils")
--
-- vim.pack.add({ "https://github.com/al-kot/typst-preview.nvim.git" })
-- local typst = require("typst-preview")
-- typst.setup({
--     preview = {
--         position = "right",
--         ppi = 144,
--         max_width = 80,
--     },
-- })
--
-- -- stylua: ignore
-- local keymaps = {
--     { "n", "<A-n>",  function() typst.next_page() end, },
--     { "n", "<A-p>",  function() typst.prev_page() end, },
--     { "n", "<leader>tgg", function() typst.first_page() end, },
--     { "n", "<leader>tG",  function() typst.last_page() end, },
--     { "n", "<leader>td",  function() typst.stop() end, },
--     { "n", "<leader>to",  function() typst.start() end, },
--     { "n", "<leader>tr",  function() typst.refresh() end, },
-- }
--
-- for i = 1, 9 do
--     table.insert(keymaps, {
--         "n",
--         "<A-" .. i .. ">",
--         function()
--             typst.goto_page(i)
--         end,
--     })
-- end
--
-- utils.add_keybinds(keymaps)
-- require("typst-preview").start()
--
--
vim.pack.add({
    'https://github.com/chomosuke/typst-preview.nvim.git',
})

require('typst-preview').setup({
  debug = false,

  -- Custom format string to open the output link provided with %s
  -- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
  -- open_cmd = nil,
  port = 9090,
  host = '127.0.0.1',
  -- Setting this to 'always' will invert black and white in the preview
  -- Setting this to 'auto' will invert depending if the browser has enable
  -- dark mode
  -- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
  -- your choice of color inversion to images and everything else
  -- separately.
  invert_colors = 'never',
  partial_rendering = true,
  follow_cursor = true,

  -- Provide the path to binaries for dependencies.
  -- Setting this will skip the download of the binary by the plugin.
  -- Warning: Be aware that your version might be older than the one
  -- required.
  dependencies_bin = {
    tinymist = 'tinymist',
    websocat = 'websocat'
  },
  extra_args = nil,
  get_root = function(path_of_main_file)
    local root = os.getenv 'TYPST_ROOT'
    if root then
      return root
    end

    local main_dir = vim.fs.dirname(vim.fn.fnamemodify(path_of_main_file, ':p'))
    local found = vim.fs.find({ 'typst.toml', '.git' }, { path = main_dir, upward = true })
    if #found > 0 then
      return vim.fs.dirname(found[1])
    end

    return main_dir
  end,
  get_main_file = function(path_of_buffer)
    return path_of_buffer
  end,
})

vim.lsp.config["tinymist"] = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
}
vim.lsp.enable("tinymist")

local utils = require("utils")

        -- colors.glow = '#98BB6C'
        -- colors.blue1 = '#76946A'
        -- colors.blue2 = '#76946A'
        -- colors.syntax = {
        --     string = '#727169'
  local gray1 = "#080808"
  local gray2 = "#191919"
  local gray3 = "#2a2a2a"
  local gray4 = "#444444"
  local gray5 = "#555555"
  local gray6 = "#7a7a7a"
  local gray7 = "#aaaaaa"
  local gray8 = "#cccccc"
  local gray9 = "#dddddd"
  local gray10 = "#f1f1f1"
  local white = "#ffffff"
utils.set_hl({
    { "StatusLineNormalMode", { bold = true, fg = "#555555", bg = "none" } },
    { "StatusLineVisualMode", { bold = true, fg = "#76946A", bg = "none" } },
    { "StatusLineInsertMode", { bold = true, fg = "#98BB6C", bg = "none" } },
    { "StatusLineNC", { bold = true, fg = "#aaaaaa", bg = "none" } },

    { "StatusLineGitBranch", { fg = "#aaaaaa", bg = "none" } },
    { "StatusLineFileName", { fg = "#7a7a7a", bg = "none" } },
    { "StatusLineFileType", { fg = "#555555", bg = "none" } },
    { "StatusLineLnCo", { fg = "#7a7a7a", bg = "none" } },
    { "StatusLinePerc", { fg = "#aaaaaa", bg = "none" } },
    { "StatusLineLSP", { fg = "#98BB6C", bg = "none" } },
})

local function git_branch()
    local branch = string.gsub(
        vim.system({ "git", "branch", "--show-current", "2>/dev/null" }, { text = true }):wait().stdout,
        "\n",
        ""
    )
    if branch ~= "" then return "%#StatusLineGitBranch#" .. branch .. " " end
    return ""
end

local function file_type()
    return "%#StatusLineFileType#" .. (vim.bo.filetype or "") .. " "
end

local function lsp_status()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients > 0 then return "%#StatusLineLSP#LSP " end
    return ""
end

local function fim_status()
    local fim = vim.g.llama_config.auto_fim
    if fim > 0 then return "%#StatusLineFileType#FIM " end
    return ""
end

local function truncate_path(path, max_levels)
    local parts = {}
    for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
    end
    local start_idx = math.max(1, #parts - max_levels + 1)
    local truncated = {}
    if start_idx ~= 1 then table.insert(truncated, "..") end
    for i = start_idx, #parts do
        table.insert(truncated, parts[i])
    end
    return table.concat(truncated, "/")
end

local function file_info()
    local size_n = vim.fn.getfsize(vim.fn.expand("%"))
    local size = ""
    local filename = truncate_path(vim.fn.expand("%"), 3)
    if size_n < 0 then
        size = ""
    elseif size_n < 1024 then
        size = size_n .. "B"
    elseif size_n < 1024 * 1024 then
        size = string.format("%.1fK", size_n / 1024)
    else
        size = string.format("%.1fM", size_n / 1024 / 1024)
    end
    if vim.bo.modified or vim.bo.buftype ~= "" or vim.bo.readonly then size = size .. " " end
    return "%#StatusLineFileName#" .. filename .. " " .. size .. "%h%m%r "
end

local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK", -- Ctrl-V
        c = "COMMAND",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK", -- Ctrl-S
        R = "REPLACE",
        r = "REPLACE",
        ["!"] = "SHELL",
        t = "TERMINAL",
    }
    local hls = {
        n = "%#StatusLineNormalMode#",
        i = "%#StatusLineInsertMode#",
        v = "%#StatusLineVisualMode#",
        V = "%#StatusLineVisualMode#",
        ["\22"] = "%#StatusLineVisualMode#", -- Ctrl-V
    }
    local str = modes[mode] or mode:upper()
    local hl = hls[mode] or "%#StatusLineNormalMode#"
    return hl .. str .. " "
end

local function line_col()
    -- local mode = vim.fn.mode()
    -- local hls = {
    --     n = "%#StatusLineNormalMode#",
    --     i = "%#StatusLineInsertMode#",
    --     v = "%#StatusLineVisualMode#",
    --     V = "%#StatusLineVisualMode#",
    --     ["\22"] = "StatusLineVisualMode", -- Ctrl-V
    -- }
    local hl = "%#StatusLineLnCo#"-- hls[mode] or "%#StatusLineNormalMode#"
    return hl .. "%l:%c  %P "
end

function _G.statusline()
    return table.concat({
        mode_icon(),
        git_branch(),
        file_info(),
        "%=",
        file_type(),
        lsp_status(),
        -- fim_status(),
        line_col(),
    })
end

function _G.statusline_inactive()
    return table.concat({
        file_info(),
        "%=",
        file_type(),
        line_col(),
    })
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        vim.cmd("set statusline=%!v:lua.statusline()")
    end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
        vim.cmd("setlocal statusline=%!v:lua.statusline_inactive()")
    end,
})

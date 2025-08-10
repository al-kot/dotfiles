local M = {}
math.randomseed(os.time())

local uv = vim.loop
local preview_dir = vim.fn.stdpath('cache') .. '/typst_preview/'
if not uv.fs_stat(preview_dir) then
    uv.fs_mkdir(preview_dir, 493)
end

local preview_tmp = preview_dir .. '/preview.typ'
local to_render = ''

local code_win = -1
local code_buf = -1
local img_win = -1
local img_buf = -1


local function get_out_name(filename)
    local n = math.random(10000)
    return filename .. '_' .. n
end

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.typ' },
    callback = function()
        if img_buf ~= -1 then
            return
        end
        vim.api.nvim_set_hl(0, 'ImageBuffer', { bg = '#ffffff' })
        code_win = vim.api.nvim_get_current_win()
        code_buf = vim.api.nvim_get_current_buf()
        vim.cmd('rightbelow vnew')
        img_buf = vim.api.nvim_get_current_buf()
        img_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(code_win)
        vim.api.nvim_win_set_width(img_win, 76)
        vim.api.nvim_set_option_value('winhighlight', 'Normal:ImageBuffer', { win = img_win })
    end
})

vim.api.nvim_create_autocmd('QuitPre', {
    pattern = { '*.typ' },
    callback = function()
        if img_buf == -1 then
            return
        end
        vim.api.nvim_buf_delete(img_buf, { force = true })
        img_buf = -1
    end
})

local function get_code_buf_content()
    return table.concat(vim.api.nvim_buf_get_lines(code_buf, 0, -1, false), '\n')
end

local function write_tmp_content(lines)
    local fd = io.open(preview_tmp, 'w')
    if fd == nil then
        print('Error could not open tmp file: ' .. preview_tmp)
        return false
    end
    fd:write(lines)
    fd:close()
    return true
end

local job_id = -1

function M.compile_and_render()
    if img_buf == -1 then
        return
    end
    local lines = get_code_buf_content()
    if not write_tmp_content(lines) then
        print('compile fail (no tmp file)')
        return
    end
    if job_id ~= -1 then
        vim.fn.jobstop(job_id)
        job_id = -1
    end

    local last_save = preview_dir .. get_out_name(vim.fn.expand('%:t:r')) .. '.png'

    job_id = vim.fn.jobstart({ 'typst', 'compile', '-f', 'png', preview_tmp, last_save }, {
        on_exit = function(_, code, _)
            if code == 0 then
                to_render = last_save
                require('snacks.image.placement').new(img_buf, to_render)
            else
                print('compile fail')
            end
            job_id = -1
        end
    })
end

-- local timer = vim.loop.hrtime()
vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    pattern = { '*.typ' },
    callback = function()
        -- if (vim.loop.hrtime() - timer) / 1e6 > 500 then
        M.compile_and_render()
        -- timer = vim.loop.hrtime()
        -- end
    end
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { '*.typ' },
    callback = function()
        M.compile_and_render()
    end,
})

return M

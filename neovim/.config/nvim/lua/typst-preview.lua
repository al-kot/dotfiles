local utils = require('utils')
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

local comp_job_id = -1

local page_number = 1
local cur_page = 1
local pages = {}

local render_count = 0
local clear_cache_treshold = 5

local function get_out_name(filename)
    local n = math.random(10000)
    return filename .. '_' .. n
end


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

local function clear_cache()
    local to_remove = { 'rm', '-f' }
    local fd = io.popen('ls -pa ' .. preview_dir .. ' | grep -v /')
    if fd == nil then
        print('Error could not open cache dir: ' .. preview_dir)
        return false
    end
    for fname in fd:lines() do
        local file_path = preview_dir .. fname
        for _, page in pairs(pages) do
            if file_path == page then
                goto continue
            end
        end
        table.insert(to_remove, file_path)
        ::continue::
    end
    fd:close()
    vim.fn.jobstart(to_remove, {
        on_exit = function(_, code, _)
            if code ~= 0 then
                print('clear cache fail')
            end
        end
    })
end

local function render_snacks(buf, img_path)
    require('snacks.image.placement').new(buf, img_path, { inline = false })
end

local function compile_and_render()
    if img_buf == -1 then
        return
    end
    local lines = get_code_buf_content()
    if not write_tmp_content(lines) then
        print('compile fail (no tmp file)')
        return
    end
    if comp_job_id ~= -1 then
        vim.fn.jobstop(comp_job_id)
        comp_job_id = -1
    end

    local last_save = preview_dir .. get_out_name(vim.fn.expand('%:t:r')) .. '.png'

    comp_job_id = vim.fn.jobstart({ 'typst', 'compile', '-f', 'png', '--pages', '' .. cur_page, preview_tmp, last_save },
        {
            on_exit = function(_, code, _)
                if code == 0 then
                    to_render = last_save
                    render_snacks(img_buf, to_render)
                    pages[cur_page] = last_save
                    render_count = render_count + 1
                    if render_count > clear_cache_treshold then
                        clear_cache()
                        render_count = 0
                    end
                else
                    print('compile fail')
                end
                comp_job_id = -1
            end
        })
end

local function update_page_number()
    if img_buf == -1 then
        return
    end
    local lines = get_code_buf_content()
    if not write_tmp_content(lines) then
        print('compile fail (tmp file)')
        return
    end

    local target = preview_dir .. get_out_name(vim.fn.expand('%:t:r')) .. '.pdf'

    local comp_res = vim.system({ 'typst', 'compile', '-f', 'pdf', preview_tmp, target }):wait()
    if comp_res.code ~= 0 then
        return
    end
    local pdfinfo_res = vim.system({ vim.o.shell, vim.o.shellcmdflag, 'pdfinfo ' ..
    target .. ' | grep Pages | awk \'{print $2}\'' }):wait()
    if pdfinfo_res.code ~= 0 then
        return
    end
    local new_page_number = tonumber(pdfinfo_res.stdout)
    if not new_page_number or new_page_number <= 0 then
        print('failed to convert the page_number: ' .. pdfinfo_res.stdout)
        return
    end
    page_number = new_page_number
end

local function change_page(n)
    cur_page = cur_page + n
    if cur_page > page_number then
        local prev_page_num = page_number
        update_page_number()
        if prev_page_num == page_number then
            cur_page = page_number
            return
        end
        change_page(0)
    end
    if cur_page < 1 then
        cur_page = 1
        return
    end
    if pages[cur_page] ~= nil then
        render_snacks(img_buf, pages[cur_page])
    else
        compile_and_render()
    end
end

local function close_img_window()
    if img_buf == -1 then
        return
    end
    vim.api.nvim_buf_delete(img_buf, { force = true })
    img_buf = -1
end

utils.add_keybinds({
    { 'n', '<leader>tn',  function() change_page(1) end },
    { 'n', '<leader>te',  function() change_page(-1) end },
    { 'n', '<leader>tgg', function() change_page(-cur_page + 1) end },
    { 'n', '<leader>tG',  function() change_page(page_number - cur_page) end },
    { 'n', '<leader>ts',  compile_and_render },
    { 'n', '<leader>td',  function()
        vim.api.nvim_clear_autocmds({ group = 'TypstPreview' })
        close_img_window()
    end },
})

-- local timer = vim.loop.hrtime()
vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    pattern = { '*.typ' },
    callback = function()
        -- if (vim.loop.hrtime() - timer) / 1e6 > 500 then
        compile_and_render()
        -- timer = vim.loop.hrtime()
        -- end
    end
})

vim.api.nvim_create_augroup('TypstPreview', {})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { '*.typ' },
    group = 'TypstPreview',
    callback = function()
        compile_and_render()
    end,
})

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.typ' },
    group = 'TypstPreview',
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
        if uv.os_uname().sysname == 'Darwin' then
            vim.api.nvim_win_set_width(img_win, 69)
        else
            vim.api.nvim_win_set_width(img_win, 76)
        end
        local loc_opts = {
            number = false,
            relativenumber = false,
            winhighlight = 'Normal:ImageBuffer',
            signcolumn = 'no',
        }
        utils.fill_table(vim.opt_local, loc_opts)

        vim.api.nvim_set_current_win(code_win)
    end
})

vim.api.nvim_create_autocmd('QuitPre', {
    pattern = { '*.typ' },
    group = 'TypstPreview',
    callback = function()
        close_img_window()
        pages = {}
        clear_cache()
    end
})

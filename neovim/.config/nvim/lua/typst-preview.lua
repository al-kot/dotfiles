local utils = require('utils')
local renderer = require('my_renderer')

local uv = vim.uv
local preview_dir = vim.fn.stdpath('cache') .. '/typst_preview/'
local preview_png = preview_dir .. vim.fn.expand('%:t:r') .. '.png'
if not uv.fs_stat(preview_dir) then
    uv.fs_mkdir(preview_dir, 493)
end

local code_win
local code_buf
local preview_win

local img_rows
local img_cols

local page_number
local cur_page = 1
local is_rendered = false
local offset

local config = {
    max_preview_width = 80,
    ppi = 144,
    preview_position = 'right',
}

local function render(data)
    renderer.render(data, offset, img_rows, img_cols)
    is_rendered = true
end
local function clear_preview()
    renderer.clear()
    is_rendered = false
end

local function get_code_buf_content()
    return table.concat(vim.api.nvim_buf_get_lines(code_buf, 0, -1, false), '\n')
end

local current_job
local function compile_and_render()
    if current_job and not current_job:is_closing() then
        current_job:close()
        current_job = nil
    end

    local cmd = 'echo \'' .. get_code_buf_content() .. '\' | typst compile -f png '
        .. '--pages ' .. cur_page .. ' --ppi ' .. config.ppi .. ' - ' .. preview_png
    current_job = uv.spawn('sh', { args = { '-c', cmd } }, function(code, _)
        current_job = nil
        if code == 0 then
            render(preview_png)
        end
    end)
end

local function update_statusline()
    vim.api.nvim_set_option_value("statusline", '%#StatusLineTypstPreview#%=' .. cur_page .. '/' .. page_number .. ' ',
        { win = preview_win })
    vim.cmd("redrawstatus")
end

local function get_page_number()
    local target_pdf = preview_dir .. 'preview.pdf'
    local cmd = 'echo \'' .. get_code_buf_content() .. '\' | typst compile -f pdf ' ..
        ' - ' .. target_pdf .. ' ;' .. 'pdfinfo ' .. target_pdf .. ' | grep Pages | awk \'{print $2}\''
    local res = vim.system({ vim.o.shell, vim.o.shellcmdflag, cmd }):wait()
    local new_page_number = tonumber(res.stdout)
    if not new_page_number then
        print('failed to get page number: (' .. res.stdout .. ')')
        return page_number
    end
    return new_page_number
end

local function change_page(n)
    local new_page = cur_page + n
    page_number = get_page_number()
    if new_page > page_number then
        new_page = page_number
    elseif new_page < 1 then
        new_page = 1
    end

    if new_page == cur_page then
        return
    end

    cur_page = new_page
    compile_and_render()
    update_statusline()
end

local function get_image_dimensions()
    local cmd = 'echo \'' ..
        get_code_buf_content() .. '\' | typst compile -f png --pages 1 --ppi ' .. config.ppi .. ' - -'
    local res = vim.system({ vim.o.shell, vim.o.shellcmdflag, cmd }):wait()
    local data = res.stdout

    if not data then
        print('failed to compile (img dimentsions)', res.stderr)
        return
    end

    local function bytes_to_number(s)
        local b1, b2, b3, b4 = s:byte(1, 4)
        return b1 * math.pow(2, 24) + b2 * math.pow(2, 16) + b3 * math.pow(2, 8) + b4
    end

    local w = bytes_to_number(data:sub(17, 20))
    local h = bytes_to_number(data:sub(21, 24))
    return h, w
end

local update_preview_size = function()
    local ffi = require("ffi")
    ffi.cdef([[
        typedef struct {
          unsigned short row;
          unsigned short col;
          unsigned short xpixel;
          unsigned short ypixel;
        } winsize;
        int ioctl(int, int, ...);
    ]])

    local TIOCGWINSZ = nil
    if vim.fn.has("linux") == 1 then
        TIOCGWINSZ = 0x5413
    elseif vim.fn.has("mac") == 1 then
        TIOCGWINSZ = 0x40087468
    elseif vim.fn.has("bsd") == 1 then
        TIOCGWINSZ = 0x40087468
    end

    ---@type { row: number, col: number, xpixel: number, ypixel: number }
    local sz = ffi.new("winsize")
    assert(ffi.C.ioctl(1, TIOCGWINSZ, sz) == 0, "Failed to get terminal size")

    local cell_height = sz.ypixel / sz.row
    local cell_width = sz.xpixel / sz.col
    local img_height, img_width = get_image_dimensions()
    local window_height = vim.api.nvim_win_get_height(code_win)

    local rows = window_height
    local cols = math.ceil((cell_height * rows * img_width) / (img_height * cell_width))
    if cols > config.max_preview_width then
        cols = config.max_preview_width
        rows = math.ceil((cell_width * cols * img_height) / (img_width * cell_height))
    end
    img_rows = rows
    img_cols = cols
    if preview_win then
        vim.api.nvim_win_set_width(preview_win, img_cols)
        offset = vim.fn.win_screenpos(preview_win)[2]
    end
end

local function setup_preview_win()
    code_win = vim.api.nvim_get_current_win()
    code_buf = vim.api.nvim_get_current_buf()

    update_preview_size()
    preview_win = vim.api.nvim_open_win(0, false, {
        split = config.preview_position,
        win = 0,
        width = img_cols,
        focusable = false,
        vertical = true,
        style = 'minimal',
    })
    local img_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(preview_win, img_buf)
    offset = vim.fn.win_screenpos(preview_win)[2]

    if config.preview_position == 'left' then
        vim.schedule(function() vim.api.nvim_set_current_win(code_win) end)
    end
end

local function open_preview()
    setup_preview_win()
    if not page_number then
        page_number = get_page_number()
    end
    if uv.fs_stat(preview_png) then
        render(preview_png)
    else
        compile_and_render()
    end
end

local function close_preview()
    clear_preview()
    vim.api.nvim_win_close(preview_win, true)
    preview_win = nil
end



local function setup_autocmds()
    vim.api.nvim_create_augroup('TypstPreview', {})

    vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
        pattern = { '*.typ' },
        group = 'TypstPreview',
        callback = function()
            compile_and_render()
        end
    })

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
            if not preview_win then
                open_preview()
            end
            vim.api.nvim_set_hl(0, "StatusLineTypstPreview", { bold = true, fg = '#83a598', bg = 'none' })
            update_statusline()
        end
    })

    vim.api.nvim_create_autocmd('QuitPre', {
        pattern = { '*.typ' },
        group = 'TypstPreview',
        callback = function()
            close_preview()
        end
    })

    vim.api.nvim_create_autocmd('VimSuspend', {
        -- pattern = { '*.typ' }, -- idk why but the event is not fired with the pattern set
        group = 'TypstPreview',
        callback = function()
            if vim.bo.filetype == 'typst' and is_rendered then
                clear_preview()
            end
        end
    })

    vim.api.nvim_create_autocmd('VimResume', {
        -- pattern = { '*.typ' }, -- idk why but the event is not fired with the pattern set
        group = 'TypstPreview',
        callback = function()
            if vim.bo.filetype == 'typst' then
                if uv.fs_stat(preview_png) then
                    render(preview_png)
                else
                    compile_and_render()
                end
            end
        end
    })

    vim.api.nvim_create_autocmd('FocusLost', {
        pattern = { '*.typ' },
        group = 'TypstPreview',
        callback = function()
            clear_preview()
        end
    })

    vim.api.nvim_create_autocmd("VimResized", {
        pattern = { '*.typ' },
        group = 'TypstPreview',
        callback = function()
            update_preview_size()
            render(preview_png)
        end,
    })
end
setup_autocmds()

utils.add_keybinds({
    { 'n', '<leader>tn',  function() change_page(1) end },
    { 'n', '<leader>te',  function() change_page(-1) end },
    { 'n', '<leader>tgg', function() change_page(-cur_page + 1) end },
    { 'n', '<leader>tG',  function() change_page(page_number - cur_page) end },
    { 'n', '<leader>tr',  compile_and_render },
    { 'n', '<leader>tc',  clear_preview },
    { 'n', '<leader>td', function()
        vim.api.nvim_clear_autocmds({ group = 'TypstPreview' })
        close_preview()
    end },
    { 'n', '<leader>to', function()
        open_preview()
        setup_autocmds()
    end },
})




-- print(vim.inspect(cached_size))

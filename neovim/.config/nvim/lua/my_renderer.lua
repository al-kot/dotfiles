local my_codes = {
    keys = {
        action = "a",
        image_id = "i",
        quiet = "q",
        transmit_format = "f",
        transmit_medium = "t",
        display_cursor_policy = "C",
        display_zindex = "z",
        display_delete = "d",
        display_columns = "c",
        display_rows = "r",
    },
    action = {
        transmit = "t",
        transmit_and_display = "T",
        delete = "d",
        display = "p",
    },
    transmit_format = {
        png = 100,
    },
    transmit_medium = {
        file = "f",
        direct = 'd',
    },
    display_cursor_policy = {
        do_not_move = 1,
    },
}
local uv = vim.uv
if not uv then uv = vim.loop end

local is_tmux = true

local stdout = vim.loop.new_tty(1, false)
if not stdout then
    print('could not open stdout')
    return
end

local function escape_tmux(sequence)
    return "\27Ptmux;" .. sequence:gsub("\27", "\27\27") .. "\27\\"
end

local function write(data, escape)
    if data == "" then return end

    local payload = data
    if escape and is_tmux then payload = escape_tmux(data) end
    stdout:write(payload)
end

-- local get_chunked = function(str)
--     local chunks = {}
--     for i = 1, #str, 4096 do
--         local chunk = str:sub(i, i + 4096 - 1):gsub("%s", "")
--         if #chunk > 0 then table.insert(chunks, chunk) end
--     end
--     return chunks
-- end

local function write_graphics(config, data)
    local control_payload = ""

    for k, v in pairs(config) do
        if v ~= nil then
            local key = my_codes.keys[k]
            if key then
                if type(v) == "number" then
                    v = string.format("%d", v)
                end
                control_payload = control_payload .. key .. "=" .. v .. ","
            end
        end
    end
    control_payload = control_payload:sub(0, -2)

    if data then
        data = vim.base64.encode(data):gsub("%-", "/")
        write("\27_G" .. control_payload .. ";" .. data .. "\27\\", true)

        -- local chunks = get_chunked(data)
        -- local m = #chunks > 1 and 1 or 0
        -- print(m)
        -- control_payload = control_payload .. ",m=" .. m
        -- for i = 1, #chunks do
        --     write("\27_G" .. control_payload .. ";" .. chunks[i] .. "\27\\", true)
        --     if i == #chunks - 1 then
        --         control_payload = "m=0"
        --     else
        --         control_payload = "m=1"
        --     end
        --     uv.sleep(1)
        -- end
    else
        write("\27_G" .. control_payload .. "\27\\", true)
    end
end

local move_cursor = function(x, y, save)
    if save then write("\27[s") end
    write("\27[" .. y .. ";" .. x .. "H")
    uv.sleep(1)
end

local restore_cursor = function()
    write("\27[u")
end

local function render(data, offset, img_rows, img_cols)
    write_graphics({
        action = my_codes.action.transmit,
        transmit_format = my_codes.transmit_format.png,
        transmit_medium = my_codes.transmit_medium.file,
        display_cursor_policy = my_codes.display_cursor_policy.do_not_move,
        -- display_columns = 10,
        -- display_rows = 10,
        quiet = 2,
        image_id = 1,
    }, data)
    move_cursor(offset, 0, true)

    write_graphics({
        action = my_codes.action.display,
        display_columns = img_cols,
        display_rows = img_rows,
        quiet = 2,
        display_zindex = -1,
        display_cursor_policy = my_codes.display_cursor_policy.do_not_move,
        image_id = 1,
    })
    restore_cursor()
end

local clear = function(image_id)
    if image_id then
        write_graphics({
            action = my_codes.action.delete,
            display_delete = "i",
            image_id = 1,
            quiet = 2,
        })
        return
    end

    write_graphics({
        action = my_codes.action.delete,
        display_delete = "a",
        quiet = 2,
    })
end

return {
    render = render,
    clear = clear,
}

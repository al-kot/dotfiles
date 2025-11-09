local M = {}

function M.fill_table(table, values)
    for k, v in pairs(values) do
        table[k] = v
    end
end

function M.add_keybinds(binds)
    for _, bind in ipairs(binds) do
        if #bind == 4 then
            vim.keymap.set(bind[1], bind[2], bind[3], bind[4])
        else
            vim.keymap.set(bind[1], bind[2], bind[3])
        end
    end
end

function M.del_keybinds(binds)
    for _, bind in ipairs(binds) do
        vim.keymap.del(bind[1], bind[2])
    end
end

function M.set_hl(hls)
    for _, hl in ipairs(hls) do
        if #hl == 3 then
            vim.api.nvim_set_hl(hl[1], hl[2], hl[3])
        else
            vim.api.nvim_set_hl(0, hl[1], hl[2])
        end
    end
end

return M

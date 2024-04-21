function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end

    return count
end

function select_previous_tab()
    vim.g.hulvdan_DisableAnimations()

    local current = vim.api.nvim_get_current_buf()
    local state = require('barbar.state')
    local count = tablelength(state.buffers)

    if current == nil then
        vim.cmd(string.format("BufferGoto %s", count), false)
        vim.fn.execute("NvuiAnimationsEnabled v:true")
        return
    end

    for i, buffer_number in ipairs(state.buffers) do
        if buffer_number == current then
            i = i - 1
            if i <= 0 then
                i = count
            end

            vim.cmd(string.format("BufferGoto %s", i), false)
            break
        end
    end

    vim.g.hulvdan_EnableAnimations()
end

function select_next_tab()
    vim.g.hulvdan_DisableAnimations()

    local current = vim.api.nvim_get_current_buf()
    local state = require('barbar.state')
    local count = tablelength(state.buffers)

    if current == nil then
        vim.cmd(string.format("BufferGoto %s", count), false)
        vim.fn.execute("NvuiAnimationsEnabled v:true")
        return
    end

    for i, buffer_number in ipairs(state.buffers) do
        if buffer_number == current then
            i = i + 1
            if (i > count) then
                i = 1
            end

            vim.cmd(string.format("BufferGoto %s", i), false)
        end
    end

    vim.g.hulvdan_EnableAnimations()
end

-- Bindings
local opts = { remap = false, silent = true }
vim.keymap.set("n", "<C-S-T>", ":BufferRestore<CR>", opts)
vim.keymap.set("t", "<C-S-T>", ":BufferRestore<CR>", opts)

-- vim.keymap.set("n", "<leader>v", select_previous_tab, opts)
-- vim.keymap.set("n", "<leader>m", select_next_tab, opts)
vim.keymap.set("n", "<A-v>", select_previous_tab, opts)
vim.keymap.set("n", "<A-m>", select_next_tab, opts)
vim.keymap.set("n", "<A-S-v>", ":BufferMovePrevious<CR>", opts)
vim.keymap.set("n", "<A-S-m>", ":BufferMoveNext<CR>", opts)

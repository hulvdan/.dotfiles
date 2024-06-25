-- MY SHORTCUTS --
-- ============ --
vim.fn.execute("set splitright")
-- vim.g.mapleader = " "
local opts = { remap = false, silent = true }

-- Moving lines updown with Shift-K / Shift-J in the visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- The best remap ever
vim.keymap.set("n", "Q", "<nop>", opts)
vim.keymap.set("i", "<f20>", "<nop>", opts)
vim.keymap.set("i", "<f24>", "<nop>", opts)
vim.keymap.set("i", "<f20><space>", " ", opts)
vim.keymap.set("i", "<f24><space>", " ", opts)
vim.keymap.set("n", "<C-l>", "<nop>", opts)
vim.keymap.set({ "n", "v" }, "<A-z>", function()
    vim.fn.execute("set wrap!")
end, opts)

-- Binding Ctrl+\ Ctrl+N to ESC makes us able to leave the terminal mode
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)

-- Open lazygit
vim.keymap.set("n", "gl", function()
    -- TODO: Make it OS agnostic
    -- TODO: Focus if it's already running (based on the window's title - there's a path displayed)
    vim.fn.system("start /MAX lazygit")
end, opts)

-- Open github desktop
vim.keymap.set("n", "gd", function()
    vim.fn.system("github")
end, opts)

-- Skipping blocks of code but making it more convenient for my keyboard setup.
-- Also, in normal mode these jumps don't pollute the jumps list
vim.keymap.set("n", "<C-J>", ":keepjumps norm! }<CR>", opts)
vim.keymap.set("n", "<C-K>", ":keepjumps norm! {<CR>", opts)
vim.keymap.set("v", "<C-J>", "}", opts)
vim.keymap.set("v", "<C-K>", "{", opts)
-- Broken because of windows' Ctrl Shift shiet in terminals
-- vim.keymap.set("n", "<C-S-J>", ":keepjumps norm! )<CR>", opts)
-- vim.keymap.set("n", "<C-S-K>", ":keepjumps norm! (<CR>", opts)
-- vim.keymap.set("v", "<C-S-J>", ")", opts)
-- vim.keymap.set("v", "<C-S-K>", "(", opts)

vim.keymap.set({ "n", "t" }, "<A-q>", ":bdelete!<CR>", opts)

vim.keymap.set("n", [[<leader>\]], function()
    vim.fn.execute("vs")
    vim.fn.execute("wincmd h")
end, opts)
vim.keymap.set("n", [[<leader>|]], function()
    vim.fn.execute("vs")
end, opts)

function OpenNotes()
    vim.fn.execute([[e ~/GoogleDrive/Media/Documents/notes.md]])
end

vim.keymap.set("n", "<leader>n", OpenNotes, opts)

-- VIM-VISUAL-MULTI --
-- ================ --
vim.keymap.set("n", "<A-J>", "<C-Down>", { silent = true, remap = true })
vim.keymap.set("n", "<A-K>", "<C-Up>", { silent = true, remap = true })

-- vim.keymap.set("n", "<f2>", vim.diagnostic.goto_next, opts)
-- vim.keymap.set("n", "<S-f2>", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "<f2>", ":cc<CR>:cn<CR>", opts)
vim.keymap.set("n", "<S-f2>", ":cc<CR>:cp<CR>", opts)

vim.keymap.set("n", "<M-[>", function()
    require("tree-climber").goto_parent()
end, { silent = true })

-- NOTE: Возвращает выделенный текст на самой верхней строке
function get_selected_text()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))
    if ls > le then
        t = le
        le = ls
        ls = t
        t = cs
        cs = ce
        ce = t
    end
    if ls == le then
        if cs > ce then
            t = cs
            cs = ce
            ce = t
        end
    end
    return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1]
end

-- Поиск в одном буфере
vim.keymap.set("v", "<A-n>", function()
    local text = get_selected_text()
    vim.api.nvim_input("<ESC>/\\C" .. text .. "<CR>")
end, opts)

vim.keymap.set("n", "<A-n>", function()
    local text = vim.fn.expand("<cword>")
    vim.api.nvim_feedkeys([[/\<]] .. text .. [[\>]], "m", false)
    vim.api.nvim_input("<CR>")
end, opts)

-- Поиск и замена с подтверждением в одном буфере
vim.keymap.set("v", "<A-r>", function()
    local text = get_selected_text()
    vim.api.nvim_input([[:<BS><BS><BS><BS><BS>]])
    vim.api.nvim_input(string.format([[.,$s/%s/%s/gc]], text, text))
    vim.defer_fn(function()
        vim.api.nvim_input([[<left><left><left>a<BS>]])
    end, 1)
end)

vim.keymap.set("n", "<A-r>", function()
    local text = vim.fn.expand("<cword>")
    vim.api.nvim_input(string.format([[:.,$s/\<lt>%s\>/%s/gcI]], text, text))
    vim.defer_fn(function()
        vim.api.nvim_input([[<left><left><left><left>a<BS>]])
    end, 1)
end)

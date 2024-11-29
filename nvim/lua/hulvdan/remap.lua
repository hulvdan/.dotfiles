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
vim.keymap.set("n", "<C-S-g>l", function()
    -- TODO: Make it OS agnostic
    -- TODO: Focus if it's already running (based on the window's title - there's a path displayed)
    vim.fn.system("start /MAX lazygit")
end, opts)

-- Open github desktop
vim.keymap.set("n", "<C-S-g>d", function()
    vim.fn.system("github")
end, opts)

-- Skipping blocks of code but making it more convenient for my keyboard setup.
-- Also, in normal mode these jumps don't pollute the jumps list
vim.keymap.set("n", "<C-J>", ":keepjumps norm! }<CR>", opts)
vim.keymap.set("n", "<C-K>", ":keepjumps norm! {<CR>", opts)
vim.keymap.set("n", "<C-S-J>", ":keepjumps norm! )<CR>", opts)
vim.keymap.set("n", "<C-S-K>", ":keepjumps norm! (<CR>", opts)

vim.keymap.set({ "n", "t" }, "<A-q>", function()
    if vim.bo.filetype == "qf" then
        vim.api.nvim_input([[\<C-w>p q]])
    else
        vim.fn.execute("BufDel!")
    end
end, opts)
vim.keymap.set({ "n", "t" }, "<A-S-q>", "<C-W>c", opts)

vim.keymap.set("n", "<f2>", ":cc<CR>:cn<CR>", opts)
vim.keymap.set("n", "<S-f2>", ":cc<CR>:cp<CR>", opts)
vim.keymap.set("n", "<C-}>", ":cc<CR>:cn<CR>", opts)
vim.keymap.set("n", "<C-{>", ":cc<CR>:cp<CR>", opts)

vim.keymap.set("n", [[<C-\>]], function()
    vim.fn.execute("vs")
    vim.fn.execute("wincmd h")
end, opts)
vim.keymap.set("n", [[<C-|>]], function()
    vim.fn.execute("vs")
end, opts)

vim.keymap.set("n", "gcc", "<S-v>gc", { silent = true, remap = true })
vim.keymap.set("n", "<C-/>", "gccj", { silent = true, remap = true })
vim.keymap.set("n", "<C-?>", "<S-v>gbj", { silent = true, remap = true })
vim.keymap.set("v", "<C-/>", "gc'>j", { silent = true, remap = true })
vim.keymap.set("v", "<C-?>", "gb'>j", { silent = true, remap = true })

function OpenNotes()
    vim.fn.execute([[e ~/GoogleDrive/Media/Documents/notes.md]])
end

vim.keymap.set("n", "<leader>n", OpenNotes, opts)

--------------------------------------------------------------------------------
-- VIM-VISUAL-MULTI
--------------------------------------------------------------------------------
vim.keymap.set("n", "<A-J>", "<C-Down>", { silent = true, remap = true })
vim.keymap.set("n", "<A-K>", "<C-Up>", { silent = true, remap = true })

vim.keymap.set("n", "<C-h>", require("tree-climber").swap_prev, opts)
vim.keymap.set("n", "<C-l>", require("tree-climber").swap_next, opts)

vim.keymap.set("n", "<A-[>", function()
    require("tree-climber").goto_parent()
end, opts)

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

-- Поиск и замена через Telescope и откидывание в quickfix.
--
-- Нужно указать переменную
-- `vim.g.telescope_search_and_replace_directory = "sources"`
--
function find_and_replace_in_sources(text)
    vim.api.nvim_input([[<ESC><C-S-f>]] .. '"' .. text .. '" ' .. (vim.g.telescope_search_and_replace_directory or ""))

    vim.defer_fn(function()
        vim.api.nvim_input([[<C-q>]])
        vim.api.nvim_input(string.format([[:cdo s/%s/%s/gcI]], text, text))
        vim.defer_fn(function()
            vim.api.nvim_input([[<left><left><left><left>a<BS>]])
        end, 1)
    end, 1500)
end

vim.keymap.set("n", "<C-S-r>", function()
    local text = vim.fn.expand("<cword>")
    find_and_replace_in_sources(text)
end, opts)

vim.keymap.set("v", "<C-S-r>", function()
    local text = get_selected_text()
    find_and_replace_in_sources(text)
end, opts)

vim.keymap.set("v", "<C-S-f>", function()
    local text = get_selected_text()
    vim.api.nvim_input([[<ESC><C-S-f>]] .. '"' .. text .. '" ' .. (vim.g.telescope_search_and_replace_directory or ""))
end, opts)

--------------------------------------------------------------------------------
-- Folds.
--------------------------------------------------------------------------------
function get_current_line_text()
    vim.api.nvim_input("mc^mz$mx")
    local _, ls, cs = unpack(vim.fn.getpos("'z"))
    local _, le, ce = unpack(vim.fn.getpos("'x"))
    vim.api.nvim_input("`c")
    return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})[1]
end

vim.keymap.set("n", "<C-,>", function()
    local current_line_text = get_current_line_text()

    if current_line_text:gsub("%s+", ""):startswith("#pragmaregion") then
        vim.api.nvim_input("zDzDzDzDzDzDzDzDzDzDV/#pragma endregion<CR>zf")
        return
    end

    local last_character = string.sub(current_line_text, -1)
    if (last_character == "{") or (last_character == "(") then
        vim.api.nvim_input("$")
    end

    -- NOTE: `:<ESC>` используются, т.к. не удалось сделать так,
    -- чтобы не генерились ошибки в `:mes` при удалении fold-ов,
    -- которые не существуют на линии.
    vim.api.nvim_input("zDzDzDzDzDzDzDzDzDzDzf%:<esc>")
end, { silent = true, remap = false })

vim.keymap.set("v", "<C-,>", function()
    vim.api.nvim_input("zDzDzDzDzDzDzDzDzDzDzf:<esc>")
end, { silent = true, remap = false })

vim.opt.foldmethod = "manual"

--------------------------------------------------------------------------------
-- Case Changing.
--------------------------------------------------------------------------------
-- function M.to_snake_case(str)
--     local parts = vim.split(M.to_dash_case(str), "-")
--     return table.concat(parts, "_")
-- end
--
-- function M.to_pascal_case(str)
--     local parts = vim.split(M.to_dash_case(str), "-")
--     return table.concat(utils.map(parts, toTitle), "_")
-- end

local textcase = require("textcase")
-- local textcase_shared = require("textcase.shared")
-- local textcase_strings_coerce_methods = require("textcase.strings.coerce.methods")

-- function map(tbl, f)
--     local t = {}
--     for k, v in pairs(tbl) do
--         t[k] = f(v)
--     end
--     return t
-- end
--
-- function to_jblow_case(str)
--     local parts = vim.split(textcase.api.to_dash_case(str), "-")
--     return table.concat(map(parts, textcase.api.to_pascal_case), "_")
-- end
--
-- textcase.api.to_jblow_case = to_jblow_case

-- textcase_strings_coerce_methods.to_jblow_case = to_jblow_case

-- ref: https://github.com/johmsalas/text-case.nvim/tree/main
--
-- Для одного слова:          space +         ( cs | cc | cC | cp )
-- Для рефакторинга в буфере: space + space + ( cs | cc | cC | cp )
--
for i, values in ipairs({
    { "cs", textcase.api.to_snake_case, "to_snake_case" },
    { "cc", textcase.api.to_camel_case, "to_camel_case" },
    { "cC", textcase.api.to_constant_case, "to_constant_case" },
    { "cp", textcase.api.to_pascal_case, "to_pascal_case" },
    -- { "cS", to_jblow_case, "to_jblow_case" },
    -- { "cS", to_jblow_case, to_jblow_case },
}) do
    vim.keymap.set("n", "<leader><leader>" .. values[1], function()
        local text = vim.fn.expand("<cword>")
        local new_text = values[2](text)
        vim.api.nvim_input(string.format([[:.,$s/\<lt>%s\>/%s/gcI]], text, new_text))
        vim.defer_fn(function()
            vim.api.nvim_input([[<left><left><left><left>a<BS>]])
        end, 1)
    end, opts)

    vim.keymap.set("v", "<leader><leader>" .. values[1], function()
        local text = get_selected_text()
        local new_text = values[2](text)
        vim.api.nvim_input([[:<BS><BS><BS><BS><BS>]])
        vim.api.nvim_input(string.format([[.,$s/%s/%s/gc]], text, new_text))
        vim.defer_fn(function()
            vim.api.nvim_input([[<left><left><left>a<BS>]])
        end, 1)
    end, opts)

    vim.keymap.set("n", "<leader>" .. values[1], function()
        textcase.current_word(values[3])
    end, opts)

    vim.keymap.set("v", "<leader>" .. values[1], function()
        textcase.visual(values[3])
    end, opts)
end

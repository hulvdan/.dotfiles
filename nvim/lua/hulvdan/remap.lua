-- MY SHORTCUTS --
-- ============ --
vim.g.mapleader = " "
local opts = { remap = false, silent = true }

-- Moving lines updown with Shift-K / Shift-J in the visual move
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- The best remap ever
vim.keymap.set("n", "Q", "<nop>", opts)
vim.keymap.set("n", "<f1>", "<nop>", opts)
vim.keymap.set("i", "<f20>", "<nop>", opts)
vim.keymap.set("i", "<f24>", "<nop>", opts)
vim.keymap.set("i", "<f20><space>", " ", opts)
vim.keymap.set("i", "<f24><space>"," ", opts)

-- Bind Ctrl+\ Ctrl+N to ESC. Makes it able to leave terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)

-- Binding Git functions
-- Ctrl-Shift-G + l - Opens lazygit
vim.keymap.set("n", "<C-S-g>l", function()
    -- TODO: Make it OS agnostic
    -- TODO: Focus if it's already running (based on the window's title - there's a path displayed)
    vim.fn.system("start /MAX lazygit")
end, opts)

-- Ctrl-Shift-G + l - Opens Github Desktop
vim.keymap.set("n", "<C-S-g>d", function()
    vim.fn.system("github")
end, opts)

-- Skipping blocks of code but making it more convenient for my keyboard setup
vim.keymap.set({"n", "v"}, "<C-J>", ":keepjumps norm! }<CR>", opts)
vim.keymap.set({"n", "v"}, "<C-K>", ":keepjumps norm! {<CR>", opts)
vim.keymap.set({"n", "v"}, "<C-S-J>", ":keepjumps norm! )<CR>", opts)
vim.keymap.set({"n", "v"}, "<C-S-K>", ":keepjumps norm! (<CR>", opts)

function WindowsCount()
    local count = 0
    for _, a in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        count = count + 1
    end
    return count
end

-- vim.keymap.set("n", "<leader>q", ":bdelete!<CR>", opts)
-- vim.keymap.set("t", "<leader>q", ":bdelete!<CR>", opts)

vim.keymap.set({"n", "t"}, "<leader>q", function()
    local count = WindowsCount()

    local is_term = vim.api.nvim_buf_get_name(0):find("term://", 1, true) == 1
    if count == 1 or is_term then
        vim.fn.execute(":bdelete!")
    else
        vim.fn.execute(":q")
    end
end, opts)

vim.keymap.set('n', '<f2>', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<S-f2>', vim.diagnostic.goto_prev, opts)

vim.keymap.set("n", "<C-\\>", function()
    vim.fn.execute("vs")
end, opts)
vim.keymap.set("n", "<C-S-\\>", function()
    vim.fn.execute("vs")
    vim.fn.execute("wincmd l")
end, opts)

-- TELESCOPE --
-- ========= --
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fn', function()
  vim.fn.execute('Telescope find_files hidden=true')
end, opts)

vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, opts)
vim.keymap.set('n', '<C-S-f>', telescope_builtin.live_grep, opts)

-- BOOKMARKS --
-- ========= --
vim.keymap.set('n', '<A-j>', function() vim.fn.execute(':BookmarkPrev') end, opts)
vim.keymap.set('n', '<A-l>', function() vim.fn.execute(':BookmarkNext') end, opts)
vim.keymap.set('n', '<A-k>', function() vim.fn.execute(':BookmarkToggle') end, opts)

function OpenNotes()
    local notes_path = [[~/GoogleDrive/Media/Documents/notes.md]]
    vim.fn.execute("e " .. notes_path)
end

vim.keymap.set('n', '<leader>n', OpenNotes, opts)

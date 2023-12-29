-- MY SHORTCUTS --
-- ============ --
vim.g.mapleader = " "
local opts = { remap = false, silent = true }

-- Moving lines updown with Shift-K / Shift-J in the visual move
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- The best remap ever
vim.keymap.set("n", "Q", "<nop>", opts)

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
vim.keymap.set({"n", "v"}, "<C-J>", "}", opts)
vim.keymap.set({"n", "v"}, "<C-K>", "{", opts)
vim.keymap.set({"n", "v"}, "<C-S-J>", ")", opts)
vim.keymap.set({"n", "v"}, "<C-S-K>", "(", opts)

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


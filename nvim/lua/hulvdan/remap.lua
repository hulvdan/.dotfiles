vim.g.mapleader = " "

local opts = { remap = false, silent = true }

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

vim.keymap.set("n", "Q", "<nop>", opts)

-- Bind Ctrl+\ Ctrl+N to ESC. Makes it able to leave terminal mode
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)

vim.keymap.set("n", "<C-S-g>l", function()
    -- TODO: Make it os agnostic
    -- TODO: Focus if it's already running (based on the window's title - there's a path displayed)
    vim.fn.system("start /MAX lazygit")
end, opts)

vim.keymap.set("n", "<C-S-g>d", function()
    vim.fn.system("github")
end, opts)


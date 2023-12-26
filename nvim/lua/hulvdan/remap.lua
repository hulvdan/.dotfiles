vim.g.mapleader = " "

local opts = { remap = false, silent = true }
vim.keymap.set("n", "\\e", ":edit ~/dev/.dotfiles/nvim/<CR>", opts)
vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<CR>", opts)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- vim.keymap.set("x", "<leader>p", "\"_dP")
-- greatest remap ever (pasting w/o replacing content)

vim.keymap.set("n", "Q", "<nop>", opts)
vim.keymap.set("n", "\\r", ":source $MYVIMRC<CR>:echo \"Config Sourced!\"<CR>", opts)

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)


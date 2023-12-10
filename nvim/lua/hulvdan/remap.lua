vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<CR>")

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- vim.keymap.set("x", "<leader>p", "\"_dP")
-- greatest remap ever (pasting w/o replacing content)

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "\\r", ":source $MYVIMRC<CR>:echo \"Config Sourced!\"<CR>")

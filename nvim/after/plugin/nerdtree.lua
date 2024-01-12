vim.g.NERDTreeShowHidden=1

local opts = { remap = false, silent = true }
vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<CR>", opts)

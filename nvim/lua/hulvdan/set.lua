-- TODO: CHECK ON OTHER DEVICES!
vim.api.nvim_command('source ~/.vimrc')

-- Essential shiet
vim.opt.nu = false
vim.opt.relativenumber = false
vim.opt.errorbells = false
vim.opt.belloff = "all"
vim.opt.termguicolors = true
vim.opt.hidden = true

-- Tabs and indent settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Swap files
vim.opt.swapfile = false
vim.opt.backup = false

-- Undo files
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.vim/undodir/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Number of lines to keep above/below the cursor
vim.opt.scrolloff = 8

-- Column with extra info
vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "1"

vim.opt.termguicolors = true

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.opt.wrap = true

vim.wo.signcolumn = "yes:1"

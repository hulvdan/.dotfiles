-- HACKS for nvui
function EnableAnimations_()
    if vim.g.hulvdan_is_nvui then
        vim.fn.execute("NvuiScrollAnimationDuration 0.16")
    end

    -- if vim.g.hulvdan_is_neovide then
    --     vim.g.neovide_scroll_animation_length = 0.13
    --     vim.g.neovide_cursor_animation_length = 0.08
    --     vim.g.neovide_scroll_animation_far_lines = 1
    --     vim.g.neovide_cursor_trail_size = 0.6
    -- end
end

function EnableAnimations()
    -- if vim.g.hulvdan_is_nvui or vim.g.hulvdan_is_neovide then
    if vim.g.hulvdan_is_nvui then
        vim.defer_fn(EnableAnimations_, 1)
    end
end

function DisableAnimations_()
    if vim.g.hulvdan_is_nvui then
        vim.fn.execute("NvuiScrollAnimationDuration 0.03")
    end

    -- if vim.g.hulvdan_is_neovide then
    --     vim.g.neovide_scroll_animation_length = 0.018
    --     vim.g.neovide_cursor_animation_length = 0
    --     vim.g.neovide_scroll_animation_far_lines = 1
    -- end
end

function DisableAnimations()
    DisableAnimations_()
end

vim.g.hulvdan_DisableAnimations = DisableAnimations
vim.g.hulvdan_EnableAnimations = EnableAnimations

-- TODO: CHECK ON OTHER DEVICES!
vim.api.nvim_command("source ~/.vimrc")

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

vim.opt.colorcolumn = ""

vim.opt.wrap = true

vim.wo.signcolumn = "yes:1"

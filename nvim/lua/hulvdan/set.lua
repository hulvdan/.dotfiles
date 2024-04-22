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

-- Undo files
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.vim/undodir/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Number of lines to keep above/below the cursor
vim.opt.scrolloff = 8

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.hulvdan_fontsize = 14
vim.g.neovide_scroll_animation_length = 0.16
vim.g.neovide_hide_mouse_when_typing = true

local high_cap = 22;
local low_cap = 10;

function AdjustFontSize(amount)
    vim.g.hulvdan_fontsize = vim.g.hulvdan_fontsize + amount
    if vim.g.hulvdan_fontsize > high_cap then
        vim.g.hulvdan_fontsize = high_cap
    end
    if vim.g.hulvdan_fontsize < low_cap then
        vim.g.hulvdan_fontsize = low_cap
    end

    local f = "For use only at ilovetypography.com"
    -- local f = "For use at ilovetypography.com only"
    -- local f = "Comic Mono"
    f = f:gsub("% ", "\\ ")
    vim.fn.execute([[set guifont=]] .. f .. ":h" .. vim.g.hulvdan_fontsize)
    vim.fn.execute([[set cmdheight=1]])
end

local opts = { remap = false, silent = true }
local font_step = 1
vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", function() AdjustFontSize(font_step) end, opts)
vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", function() AdjustFontSize(-font_step) end, opts)
vim.keymap.set("n", "<C-_>", function() AdjustFontSize(-font_step) end, opts)
vim.keymap.set("n", "<C-+>", function() AdjustFontSize(font_step) end, opts)

AdjustFontSize(0)
-- vim.fn.execute("set linespace=-1")

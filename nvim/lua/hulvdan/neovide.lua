vim.g.hulvdan_fontsize = 13
vim.g.neovide_scroll_animation_length = 0.16
vim.g.neovide_hide_mouse_when_typing = true

function AdjustFontSize(amount)
    vim.g.hulvdan_fontsize = vim.g.hulvdan_fontsize + amount
    local f = "For use only at ilovetypography.com"
    -- local f = "For use at ilovetypography.com only"
    -- local f = "Comic Mono"
    f = f:gsub("% ", "\\ ")
    vim.fn.execute([[set guifont=]] .. f .. ":h" .. vim.g.hulvdan_fontsize)
end

local opts = { remap = false, silent = true }
local font_step = 1
vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", function() AdjustFontSize(font_step) end, opts)
vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", function() AdjustFontSize(-font_step) end, opts)
vim.keymap.set("n", "<C-_>", function() AdjustFontSize(-font_step) end, opts)
vim.keymap.set("n", "<C-+>", function() AdjustFontSize(font_step) end, opts)

AdjustFontSize(0)

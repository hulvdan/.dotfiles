vim.g.hulvdan_fontsize = 13
vim.g.neovide_scroll_animation_length = 0.16

function AdjustFontSize(amount)
    vim.g.hulvdan_fontsize = vim.g.hulvdan_fontsize + amount
    local f = "For use only at ilovetypography.com"
    -- local f = "For use at ilovetypography.com only"
    -- local f = "Comic Mono"
    f = f:gsub("% ", "\\ ")
    vim.fn.execute([[set guifont=]] .. f .. ":h" .. vim.g.hulvdan_fontsize)
end

AdjustFontSize(0)

local opts = { remap = false, silent = true }
vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", function() AdjustFontSize(1) end, opts)
vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", function() AdjustFontSize(-1) end, opts)
vim.keymap.set("n", "<C-_>", function() AdjustFontSize(-1) end, opts)
vim.keymap.set("n", "<C-+>", function() AdjustFontSize(1) end, opts)

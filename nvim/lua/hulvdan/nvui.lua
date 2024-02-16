vim.fn.execute("NvuiCursorAnimationDuration 0.13")
vim.fn.execute("NvuiScrollAnimationDuration 0.16")
vim.fn.execute("NvuiMoveAnimationDuration 0.00001")
vim.fn.execute("NvuiCursorHideWhileTyping v:true")

vim.g.hulvdan_fontsize = 14
function AdjustFontSize(amount)
    vim.g.hulvdan_fontsize = vim.g.hulvdan_fontsize + amount
    vim.fn.execute([[set guifont=For\ use\ only\ at\ ilovetypography.com:h]] .. vim.g.hulvdan_fontsize)
end

AdjustFontSize(0)

local opts = { remap = false, silent = true }
vim.keymap.set({"n", "i"}, "<C-ScrollWheelUp>", function() AdjustFontSize(1) end, opts)
vim.keymap.set({"n", "i"}, "<C-ScrollWheelDown>", function() AdjustFontSize(-1) end, opts)
vim.keymap.set("n", "<C-S-=>", function() AdjustFontSize(1) end, opts)
vim.keymap.set("n", "<C-S-_>", function() AdjustFontSize(-1) end, opts)

local opts = { remap = false, silent = true }

vim.keymap.set("n", "<leader>u", function()
    vim.cmd.UndotreeToggle()
    vim.cmd.UndotreeFocus()
end, opts)

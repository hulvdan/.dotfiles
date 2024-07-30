-- Undo files
vim.opt.undodir = vim.fn.expand("$HOME") .. "/.vim/undodir/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Number of lines to keep above/below the cursor
vim.opt.scrolloff = 8

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.breakat = " "

local overseer = require("overseer")

vim.g.hulvdan_run_command = function(cmd)
    vim.fn.execute(":wa")

    overseer
        .new_task({
            cmd = cmd,
            components = {
                { "on_output_quickfix", open = true, close = true },
                { "on_exit_set_status", success_codes = { 0 } },
                "default",
            },
        })
        :start()
end

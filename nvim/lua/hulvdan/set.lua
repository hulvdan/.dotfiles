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

-- NOTE: cmd может быть:
-- 1) строка
--      `"command"`
-- 2) table. Команды выполнятся последовательно
--      `{"command1", "command2", "command3"}`
function hulvdan_run_command(cmd)
    vim.fn.execute(":silent! wa!")

    function wrap_command(c)
        return {
            cmd = c,
            components = {
                { "on_output_quickfix", open = true, close = true },
                { "on_exit_set_status", success_codes = { 0 } },
                "default",
            },
        }
    end

    if type(cmd) == "table" then
        elems = {}
        for k, v in ipairs(cmd) do
            table.insert(elems, wrap_command(v))
        end

        overseer
            .new_task({
                name = "orchestrator",
                strategy = {
                    "orchestrator",
                    tasks = elems,
                },
            })
            :start()
    else
        overseer.new_task(wrap_command(cmd)):start()
    end
end

vim.g.hulvdan_run_command = hulvdan_run_command

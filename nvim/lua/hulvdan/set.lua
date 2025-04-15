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
                { "hulvdan/bump_quickfix_errors_on_top" },
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
                strategy = { "orchestrator", tasks = elems },
            })
            :start()
    else
        overseer.new_task(wrap_command(cmd)):start()
    end
end

function make_task(name, cmd)
    vim.fn.execute(":silent! wa!")

    function wrap_command(name_, c)
        return {
            name = name_,
            cmd = c,
            components = {
                { "on_output_quickfix", open = true, close = true },
                { "on_exit_set_status", success_codes = { 0 } },
                { "hulvdan/bump_quickfix_errors_on_top" },
                "default",
            },
        }
    end

    if type(cmd) == "table" then
        elems = {}
        for k, v in ipairs(cmd) do
            table.insert(elems, wrap_command(nil, v))
        end

        return overseer.new_task({
            name = name,
            strategy = { "orchestrator", tasks = elems },
        })
    else
        return overseer.new_task(wrap_command(name, cmd))
    end
end

function hulvdan_tasks(tasks)
    keys = {}
    for i, value in ipairs(tasks) do
        table.insert(keys, i, value[1])
    end

    vim.keymap.set("n", "<leader>a", function()
        require("fastaction").select(keys, {}, function(item)
            for i, value in ipairs(tasks) do
                if value[1] == item then
                    make_task(item, value[2]):start()
                end
            end
        end)
    end, opts)
end

vim.g.hulvdan_run_command = hulvdan_run_command
vim.g.hulvdan_tasks = hulvdan_tasks

vim.fn.execute("colorscheme rams")
vim.fn.execute("hi! link NeoTreeGitAdded Default")
vim.fn.execute("hi! link NeoTreeGitConflict Default")
vim.fn.execute("hi! link NeoTreeGitDeleted Default")
vim.fn.execute("hi! link NeoTreeGitIgnored Default")
vim.fn.execute("hi! link NeoTreeGitModified Default")
vim.fn.execute("hi! link NeoTreeGitUntracked Default")
vim.fn.execute("hi! EndOfBuffer guifg=bg")
vim.fn.execute("hi! link MiniCursorwordCurrent MiniCursorword")
vim.api.nvim_set_hl(0, "MiniCursorword", { fg = "#ebebeb", bg = "#4b4b4b" })
vim.fn.execute("hi! clear CursorLine")
vim.fn.execute("hi Folded guibg=#4b4b4b")
vim.fn.execute("hi CursorLine guifg=clear guibg=#4b4b4b")
vim.fn.execute("hi! markdownerror guibg=clear")

vim.fn.execute("hi! Comment guifg=#b8bb26")
vim.fn.execute("hi clear Todo")
vim.fn.execute("hi! link Todo comment")
vim.fn.execute("hi! link comment.error comment")
vim.fn.execute("hi! link comment.warning comment")
vim.fn.execute("hi! link comment.note comment")
vim.fn.execute("hi! link quickfixline Folded")
vim.fn.execute("hi! bufferlinefill guibg=clear")
vim.fn.execute("hi! bufferlineseparator guibg=clear")
vim.fn.execute("hi! bufferlinebackground guibg=clear")

vim.fn.execute([[set fillchars+=fold:\ ]])

-- print("INFO(zzz.lua): Sourcing '*.lua' files from .nvim-personal directory...")
for i, fpath in pairs(vim.fn.split(vim.fn.globpath(".nvim-personal", "*.lua"), "\n")) do
    -- print("INFO(zzz.lua): Sourcing " .. fpath .. "...")
    vim.fn.execute("luafile " .. fpath)
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    once = false,
    callback = function()
        local extension = vim.fn.expand("%"):match("^.+(%..+)$") -- example: `.log`

        if extension == ".md" then
            vim.fn.execute("setlocal shiftwidth=2 tabstop=2")
            return
        end
    end,
})

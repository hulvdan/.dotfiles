-- NOTE: Эта версия делает source модулей.
function custom_require(mod)
    vim.fn.execute(string.format("source %s/lua/%s.lua", vim.fn.stdpath("config"), mod))
end
-- NOTE: Эта версия делает require модулей. Они загружаются один раз.
-- function custom_require(mod)
--     require(mod)
-- end

function custom_reload(disable_message)
    if not disable_message then
        print("Executing hulvdan/init.lua - custom_reload()...")
    end

    custom_require("hulvdan/set")
    custom_require("hulvdan/remap")
    custom_require("hulvdan/chtsh")

    if vim.g.hulvdan_is_nvui then
        custom_require("hulvdan/nvui")
    end
    if vim.g.neovide then
        custom_require("hulvdan/neovide")
    elseif vim.g.hulvdan_is_qt then
        custom_require("hulvdan/nvim_qt")
    end
    if vim.g.goneovim then
        custom_require("hulvdan/goneovim")
    end
end

vim.keymap.set("n", [[\r]], custom_reload, { silent = true, remap = false })
custom_reload(true)

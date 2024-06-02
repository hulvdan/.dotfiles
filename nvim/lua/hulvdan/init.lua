-- NOTE: Эта версия делает source модулей.
function custom_require(mod)
    vim.fn.execute(string.format("luafile %s/lua/%s.lua", vim.fn.stdpath("config"), mod))
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
    if vim.g.hulvdan_is_neovide then
        custom_require("hulvdan/neovide")
    end
end

vim.keymap.set("n", [[\r]], custom_reload, { silent = true, remap = false })
custom_reload(true)

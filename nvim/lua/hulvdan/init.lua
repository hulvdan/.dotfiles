function custom_require(mod)
    vim.fn.execute(string.format("source %s/lua/%s.lua", vim.fn.stdpath("config"), mod))
end

function custom_reload(disable_message)
    if not disable_message then
        print("Executing hulvdan/init.lua - custom_reload()...")
    end

    custom_require("hulvdan/set")
    custom_require("hulvdan/remap")
end

vim.keymap.set("n", [[\r]], custom_reload, { silent = true, remap = false })
custom_reload(true)

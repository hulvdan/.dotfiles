function chtsh(opts)
    run = opts.args or nil
    local query = opts.args

    local url = [[https://cht.sh/]] .. query:gsub("% ", "+")
    print("Checking url: " .. url)
    vim.fn.execute([[term curl ]] .. url)
end

vim.api.nvim_create_user_command("H", chtsh, { nargs = "?" })

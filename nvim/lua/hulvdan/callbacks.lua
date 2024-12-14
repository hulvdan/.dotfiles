vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    once = false,
    callback = function()
        if vim.bo.filetype == "markdown" then
            vim.fn.execute("setlocal tabstop=2")
            vim.fn.execute("setlocal shiftwidth=2")
            return
        end
    end,
})

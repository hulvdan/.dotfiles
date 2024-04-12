vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = { "*.snip" },
    once = false,
    callback = function()
        vim.fn.execute("COQsnips compile")
    end
})

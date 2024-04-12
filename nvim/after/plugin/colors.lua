function SetTheme(theme)
    theme = theme or "gruvbox"
    vim.cmd.colorscheme(theme)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetTheme()
vim.fn.execute("hi NonText guifg=black")
vim.fn.execute("hi EndOfBuffer guifg=black")
vim.fn.execute("hi Comment guifg=#a38a46")

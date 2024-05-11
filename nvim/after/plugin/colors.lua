function SetTheme(theme)
    theme = theme or "gruvbox"
    vim.cmd.colorscheme(theme)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetTheme()

vim.fn.execute("hi Normal guibg=#0c1015")
vim.fn.execute("hi CursorLine guibg=#1c3349")

vim.fn.execute("hi NonText guifg=#0c1016")
vim.fn.execute("hi EndOfBuffer guifg=#0c1016")
vim.fn.execute("hi Comment guifg=#a38a46")
vim.fn.execute("hi CursorWord cterm=none gui=none guibg=#10409d")

vim.fn.execute("hi bookmarks_virt_text_hl gui=italic guifg=#8ec07c")


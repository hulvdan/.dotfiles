-- NOTE: This file gets executed after all the lua files (in the directory of this file) get executed

vim.fn.execute("colorscheme rams")
vim.fn.execute("hi! link NeoTreeGitAdded Default")
vim.fn.execute("hi! link NeoTreeGitConflict Default")
vim.fn.execute("hi! link NeoTreeGitDeleted Default")
vim.fn.execute("hi! link NeoTreeGitIgnored Default")
vim.fn.execute("hi! link NeoTreeGitModified Default")
vim.fn.execute("hi! link NeoTreeGitUntracked Default")
vim.fn.execute("hi! EndOfBuffer guifg=bg")
vim.fn.execute("hi! link MiniCursorwordCurrent MiniCursorword")
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#4b4b4b" })
vim.fn.execute("hi! clear CursorLine")
vim.fn.execute("hi! WellleContext guifg=#ebebeb guibg=#4b4b4b")

vim.fn.execute("hi! Comment guifg=#b8bb26")

-- print("INFO(zzz.lua): Sourcing '*.lua' files from .nvim-personal directory...")
for i, fpath in pairs(vim.fn.split(vim.fn.globpath(".nvim-personal", "*.lua"), "\n")) do
    -- print("INFO(zzz.lua): Sourcing " .. fpath .. "...")
    vim.fn.execute("luafile " .. fpath)
end

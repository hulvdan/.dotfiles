-- NOTE: This file gets executed after all the lua files (in the directory of this file) get executed
-- TODO: aboba

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
vim.fn.execute("hi Folded guibg=#424242")
vim.fn.execute("hi CursorLine guifg=clear guibg=#424242")
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

-- print("INFO(zzz.lua): Sourcing '*.lua' files from .nvim-personal directory...")
for i, fpath in pairs(vim.fn.split(vim.fn.globpath(".nvim-personal", "*.lua"), "\n")) do
    -- print("INFO(zzz.lua): Sourcing " .. fpath .. "...")
    vim.fn.execute("luafile " .. fpath)
end

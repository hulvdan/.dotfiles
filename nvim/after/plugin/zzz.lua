vim.fn.execute("colorscheme gruvbox")

-- DOCS: This file gets executed after all the lua files (in the directory of this file) get executed
print("INFO(zzz.lua): Sourcing '*.lua' files from .nvim-personal directory...")

for i, fpath in pairs(vim.fn.split(vim.fn.globpath(".nvim-personal", "*.lua"), "\n")) do
    print("INFO(zzz.lua): Sourcing " .. fpath .. "...")
    vim.fn.execute("luafile " .. fpath)
end

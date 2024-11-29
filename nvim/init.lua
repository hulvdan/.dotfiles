string.startswith = function(self, str)
    return self:find("^" .. str) ~= nil
end

vim.g.hulvdan_is_nvui = vim.fn.exists(":NvuiToggleFullscreen") ~= 0
vim.g.hulvdan_is_goneovim = vim.fn.exists(":GonvimVersion") ~= 0

vim.fn.execute(
    "set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.fn.execute([[source ~/.vimrc]])
require("lazy").setup("plugins")
require("hulvdan")

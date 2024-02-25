vim.g.hulvdan_is_nvui = vim.fn.exists(":NvuiToggleFullscreen") ~= 0
vim.g.hulvdan_is_neovide = vim.fn.exists(":NeovideFocus") ~= 0

require("hulvdan")

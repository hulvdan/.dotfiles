require("hulvdan/set")
require("hulvdan/packer")
require("hulvdan/remap")
require("hulvdan/chtsh")

if vim.g.hulvdan_is_nvui then
    require("hulvdan/nvui")
end

if vim.g.hulvdan_is_neovide then
    require("hulvdan/neovide")
end

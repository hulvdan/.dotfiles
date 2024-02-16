require("hulvdan/set")
require("hulvdan/packer")
require("hulvdan/remap")
require("hulvdan/chtsh")

local is_nvui = vim.fn.exists(":NvuiToggleFullscreen")
if is_nvui then
    require("hulvdan/nvui")
end

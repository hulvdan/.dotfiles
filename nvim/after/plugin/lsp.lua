local lsp = require("lsp-zero")

lsp.preset('recommended')
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'gd', '<CMD>Telescope lsp_definitions<CR>', opts)
  vim.keymap.set('n', 'gi', '<CMD>Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', 'gr', '<CMD>Telescope lsp_references<CR>', opts)
end)

lsp.setup()


local lsp = require("lsp-zero")

lsp.preset('manual-setup')
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  local opts = {buffer = bufnr, remap = false, silent = true}

  vim.keymap.set('n', '<f2>', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<S-f2>', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<S-f6>', vim.lsp.buf.rename, opts)

  vim.keymap.set('n', 'gd', '<CMD>Telescope lsp_definitions<CR>', opts)
  vim.keymap.set('n', 'gi', '<CMD>Telescope lsp_implementations<CR>', opts)
  vim.keymap.set('n', 'gr', '<CMD>Telescope lsp_references<CR>', opts)
end)

lsp.setup()


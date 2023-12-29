local lsp = require("lsp-zero")

-- Hulvdan: LSP is turned off by default
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

local function toggle_autocomplete()
  local cmp = require('cmp')
  local current_setting = cmp.get_config().completion.autocomplete
  if current_setting and #current_setting > 0 then
    cmp.setup({ completion = { autocomplete = false } })
    print('Autocomplete disabled')
  else
    cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
    print('Autocomplete enabled')
  end
end

vim.api.nvim_create_user_command('NvimCmpToggle', toggle_autocomplete, {})

-- Hulvdan: Autocompletion is turned off by default
require("cmp").setup({ completion = { autocomplete = false } })


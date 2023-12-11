-- vim.keymap.set("n", "<leader>v", ":BufferPrevious<CR>")
-- vim.keymap.set("n", "<leader>m", ":BufferNext<CR>")

function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end

  return count
end

vim.keymap.set("n", "C-S-T", ":BufferRestore<CR>")
vim.keymap.set("n", "<leader>q", ":BufferClose<CR>")

vim.keymap.set("n", "<leader>v", function()
  local current = vim.api.nvim_get_current_buf()
  local state = require('barbar.state')
  local count = tablelength(state.buffers)

  if current == nil then
    vim.cmd(string.format("BufferGoto %s", count), false)
    return
  end

  for i, buffer_number in ipairs(state.buffers) do
    if buffer_number == current then
      i = i - 1
      if i <= 0 then
        i = count
      end

      vim.cmd(string.format("BufferGoto %s", i), false)
      break
    end
  end
end)

vim.keymap.set("n", "<leader>m", function()
  local current = vim.api.nvim_get_current_buf()
  local state = require('barbar.state')
  local count = tablelength(state.buffers)

  if current == nil then
    vim.cmd(string.format("BufferGoto %s", count), false)
    return
  end

  for i, buffer_number in ipairs(state.buffers) do
    if buffer_number == current then
      i = i + 1
      if (i > count) then
        i = 1
      end

      vim.cmd(string.format("BufferGoto %s", i), false)
    end
  end
end)


require('barbar').setup({
  animation = false,
  auto_hide = 1,
  icons = {
    -- Configure the base icons on the bufferline.
    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
    buffer_index = false,
    buffer_number = false,
    button = '',
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
      [vim.diagnostic.severity.WARN] = {enabled = false},
      [vim.diagnostic.severity.INFO] = {enabled = false},
      [vim.diagnostic.severity.HINT] = {enabled = true},
    },
    gitsigns = {
      added = {enabled = true, icon = '+'},
      changed = {enabled = true, icon = '~'},
      deleted = {enabled = true, icon = '-'},
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = false,

      -- Requires `nvim-web-devicons` if `true`
      enabled = false,
    },
    separator = {left = '▎', right = ''},

    -- If true, add an additional separator at the end of the buffer list
    separator_at_end = true,

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = {button = '●'},
    pinned = {button = '', filename = true},

    -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
    preset = 'default',

    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    alternate = {filetype = {enabled = false}},
    current = {buffer_index = false},
    inactive = {button = '×'},
    visible = {modified = {buffer_number = false}},
  },
})


-- vim.keymap.set("n", "<leader>v", ":BufferPrevious<CR>")
-- vim.keymap.set("n", "<leader>m", ":BufferNext<CR>")

function tablelength(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end

  return count
end

vim.keymap.set("n", "C-U", "BufferRestore<CR>")

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
      if i == 1 then
        i = count + 1
      end

      vim.cmd(string.format("BufferGoto %s", i - 1), false)

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
      if (i == count) then
        i = 0
      end

      vim.cmd(string.format("BufferGoto %s", i + 1), false)
    end
  end
end)

vim.keymap.set("n", "<leader>q", ":BufferClose<CR>")


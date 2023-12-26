for i, fpath in pairs(vim.fn.split(vim.fn.globpath('.nvim-personal', '*.lua'), '\n')) do
  print('source ' .. fpath)
  vim.fn.execute('source ' .. fpath)
end


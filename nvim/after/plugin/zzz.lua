-- NOTE(hulvdan): This file executes after all the plugins get executed
for i, fpath in pairs(vim.fn.split(vim.fn.globpath('.nvim-personal', '*.lua'), '\n')) do
  print('INFO(project_scripts.lua): Sourcing ' .. fpath .. '...')
  vim.fn.execute('luafile ' .. fpath)
end

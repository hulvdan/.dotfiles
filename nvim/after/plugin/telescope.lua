require('telescope').setup {
  defaults = {
    file_ignore_patterns = {
      "__pycache__",
      ".git",
      ".idea",
      ".mypy_cache",
      ".pytest_cache",
      ".venv",
      "node_modules",
      "venv",
      "%.meta",
      "%.csproj",
      "%.sln",
    }
  }
}

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fn', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})


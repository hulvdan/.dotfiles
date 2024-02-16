local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup({
    defaults = {
        file_ignore_patterns = {
            "__pycache__$",
            ".git$",
            ".idea$",
            ".mypy_cache$",
            ".pytest_cache$",
            ".venv$",
            "node_modules$",
            "venv$",
            "%.meta$",
            "%.csproj$",
            "%.sln$",
            ".vs\\main$",
            "%.pdb$",
            "%.lib$",
            "%.o$",
            "%.so$",
            "%.exe$",
        }
    },
})

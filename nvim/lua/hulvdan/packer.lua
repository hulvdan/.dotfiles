vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- TODO: CHECK ON OTHER DEVICES!
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        -- or                            , branch = "0.1.x",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep" }, -- Optional
            { "nvim-telescope/telescope-live-grep-args.nvim" }, -- Optional
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }

    use("ixru/nvim-markdown") -- https://github.com/ixru/nvim-markdown
    use("mbbill/undotree")
    use("preservim/nerdtree")
    use("jansedivy/jai.vim")
    use("drybalka/tree-climber.nvim")

    use {
        "nvim-focus/focus.nvim",
        config = function()
            require("focus").setup({
                enable = true, -- Enable module
                commands = true, -- Create Focus commands
                autoresize = {
                    enable = true, -- Enable or disable auto-resizing of splits
                    width = 92, -- Force width for the focused window
                    -- height = 0, -- Force height for the focused window
                    -- minwidth = 10, -- Force minimum width for the unfocused window
                    -- minheight = 0, -- Force minimum height for the unfocused window
                    height_quickfix = 10, -- Set the height of quickfix panel
                },
                -- split = {
                --     bufnew = false, -- Create blank buffer for new split windows
                --     tmux = false, -- Create tmux splits instead of neovim splits
                -- },
                ui = {
                    -- number = false, -- Display line numbers in the focussed window only
                    -- relativenumber = false, -- Display relative line numbers in the focussed window only
                    -- hybridnumber = false, -- Display hybrid line numbers in the focussed window only
                    -- absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows
                    --
                    cursorline = false, -- Display a cursorline in the focussed window only
                    -- cursorcolumn = false, -- Display cursorcolumn in the focussed window only
                    -- colorcolumn = {
                    --     enable = false, -- Display colorcolumn in the foccused window only
                    --     list = "+1", -- Set the comma-saperated list for the colorcolumn
                    -- },
                    signcolumn = false, -- Display signcolumn in the focussed window only
                    winhighlight = true, -- Auto highlighting for focussed/unfocussed windows
                }
            })
        end
    }
    use {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                -- min_window_height = 1, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                -- line_numbers = true,
                multiline_threshold = 1, -- Maximum number of lines to show for a single context
                -- trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
                mode = "cursor",  -- Line used to calculate context. Choices: "cursor", "topline"
                -- -- Separator between context and content. Should be a single character string, like "-".
                -- -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                -- separator = "-",
                -- zindex = 20, -- The Z-index of the context window
                -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
            vim.fn.execute("hi TreesitterContext guibg=#3c3836")
        end
    }

    use {
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 200,
                },
            })
        end
    }

    use { "mg979/vim-visual-multi" }

    use {
        "romgrk/barbar.nvim",
        config = function()
            require("barbar").setup({
                animation = false,
                auto_hide = 1,
                maximum_padding = 1,
                minimum_padding = 1,
                semantic_letters = false,
                highlight_inactive_file_icons = false,
                tabpages = false,
                icons = {
                    -- Configure the base icons on the bufferline.
                    -- Valid options to display the buffer index and -number are `true`, "superscript" and "subscript"
                    buffer_index = false,
                    buffer_number = false,
                    button = "",
                    -- Enables / disables diagnostic symbols
                    diagnostics = {
                        [vim.diagnostic.severity.ERROR] = { enabled = false, icon = "E" },
                        [vim.diagnostic.severity.WARN] = { enabled = false },
                        [vim.diagnostic.severity.INFO] = { enabled = false },
                        [vim.diagnostic.severity.HINT] = { enabled = false },
                    },
                    gitsigns = {
                        added = { enabled = false, icon = "+" },
                        changed = { enabled = false, icon = "~" },
                        deleted = { enabled = false, icon = "-" },
                    },
                    filetype = {
                        -- Sets the icon's highlight group.
                        -- If false, will use nvim-web-devicons colors
                        custom_colors = false,

                        -- Requires `nvim-web-devicons` if `true`
                        enabled = false,
                    },
                    separator = { left = "▎", right = "" },

                    -- If true, add an additional separator at the end of the buffer list
                    separator_at_end = false,

                    -- Configure the icons on the bufferline when modified or pinned.
                    -- Supports all the base icon options.
                    modified = { button = "" },
                    pinned = { button = "●", filename = true },

                    -- Use a preconfigured buffer appearance— can be "default", "powerline", or "slanted"
                    preset = "default",

                    -- Configure the icons on the bufferline based on the visibility of a buffer.
                    -- Supports all the base icon options, plus `modified` and `pinned`.
                    alternate = { filetype = { enabled = false } },
                    current = { buffer_index = false },
                    inactive = { button = "" },
                    visible = { modified = { buffer_number = false } },
                },
            })
        end
    }


    vim.g.bookmark_save_per_working_dir = 1
    vim.g.bookmark_auto_save = 1
    vim.g.bookmark_sign = "📘"
    use("MattesGroeger/vim-bookmarks")
    use("mfussenegger/nvim-lint")

    use("editorconfig/editorconfig-vim")

    -- Coq
    vim.g.coq_settings = {
        auto_start = "shut-up",
        limits = {
            tokenization_limit = 3000,
        },
    }

    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim" },
            { "ms-jpq/coq_nvim", branch = "coq" },
            { "ms-jpq/coq.artifacts", after = "coq_nvim", branch = "artifacts" },
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                handlers = {
                    require("lsp-zero").default_setup,
                },
            })
        end
    }

    use({
        "cappyzawa/trim.nvim",
        config = function()
            require("trim").setup({})
        end
    })

    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({
                toggler = {
                    line = "<C-/>",
                    block = "<C-?>",
                },
            })

            local api = require("Comment.api")
            vim.keymap.set({ "n", "v" }, "<C-/>", api.call("toggle.linewise", "g@"), { expr = true })
            vim.keymap.set({ "n", "v" }, "<C-?>", api.call("toggle.linewise.current", "g@$"), { expr = true })
        end
    }

    -- vim.keymap.set("n", "<C-/>", api.call("toggle.linewise", "g@"), { expr = true })
    -- vim.keymap.set("n", "<C-?>", api.call("toggle.linewise.current", "g@$"), { expr = true })
    -- vim.keymap.set("v", "<C-/>", function() api.call("toggle.linewise", "g@") end, {remap=false, silent=true})
    -- vim.keymap.set("v", "<C-?>", function() api.call("toggle.linewise.current", "g@$") end, { expr = true })


    use { "folke/todo-comments.nvim" }
    use { "wsdjeg/vim-fetch" }
    use { "bogado/file-line" }

    use {
        "stevearc/overseer.nvim",
        config = function()
            require("overseer").setup({
                templates = { "builtin" },
            })
        end
    }

    use({
        "kylechui/nvim-surround",
        tag = "v2.1.4", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })

    use {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({
                -- terminal_colors = false, -- add neovim terminal colors
                -- undercurl = true,
                -- underline = true,
                bold = false,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                -- strikethrough = true,
                -- invert_selection = false,
                -- invert_signs = false,
                -- invert_tabline = false,
                -- invert_intend_guides = false,
                -- inverse = true, -- invert background for search, diffs, statuslines and errors
                -- contrast = "", -- can be "hard", "soft" or empty string
                -- palette_overrides = {},
                -- overrides = {},
                -- dim_inactive = true,
                -- transparent_mode = false,
            })
        end
    }
end)

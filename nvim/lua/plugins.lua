return {
    "nvim-treesitter/nvim-treesitter",

    {
        "nvim-telescope/telescope.nvim", branch = "0.1.x",
        lazy=false,
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep" }, -- Optional
            { "nvim-telescope/telescope-live-grep-args.nvim" }, -- Optional
        },
        config = function()
            telescope = require("telescope")
            telescope.setup({
                defaults = {
                    layout_config = {
                        -- vertical = { width = 1.0, height = 1.0 },
                        horizontal = { width = 0.99, height = 10000 },
                    },
                },
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
                },
            })
            telescope.load_extension("live_grep_args")
        end,
    },

    {
        "ixru/nvim-markdown",
        lazy = false,
    },

    {
        "mbbill/undotree",
        lazy = false,
    },

    -- {
        --     "preservim/nerdtree",
        --     lazy = false,
        -- },

        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
                "MunifTanjim/nui.nvim",
                -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
            },
            config = function()
                tree = require("neo-tree")
                tree.setup({
                    filesystem = {
                        filtered_items = {
                            visible = false, -- when true, they will just be displayed differently than normal items
                            hide_dotfiles = false,
                            hide_gitignored = true,
                            hide_hidden = false, -- only works on Windows for hidden files/directories
                            hide_by_name = {
                                --"node_modules"
                            },
                            hide_by_pattern = {
                                -- uses glob style patterns
                                --"*.meta",
                                --"*/src/*/tsconfig.json",
                            },
                            always_show = {
                                -- remains visible even if other settings would normally hide it
                                --".gitignored",
                            },
                            never_show = {
                                -- remains hidden even if visible is toggled to true, this overrides always_show
                                --".DS_Store",
                                --"thumbs.db"
                            },
                            never_show_by_pattern = {
                                -- uses glob style patterns
                                --".null-ls_*",
                            },
                        },
                        follow_current_file = {
                            -- This will find and focus the file in the active buffer every time
                            -- the current file is changed while the tree is open.
                            enabled = false,
                            -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                            leave_dirs_open = false,
                        },
                        -- when true, empty folders will be grouped together
                        group_empty_dirs = false,
                        -- netrw disabled, opening a directory opens neo-tree
                        -- in whatever position is specified in window.position
                        -- "open_current",  -- netrw disabled, opening a directory opens within the
                        -- window like netrw would, regardless of window.position
                        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                        hijack_netrw_behavior = "open_default",
                        -- This will use the OS level file watchers to detect changes
                        -- instead of relying on nvim autocmd events.
                        use_libuv_file_watcher = false,
                        window = {
                            mappings = {
                                ["<bs>"] = "navigate_up",
                                ["."] = "set_root",
                                ["H"] = "toggle_hidden",
                                ["/"] = "fuzzy_finder",
                                ["D"] = "fuzzy_finder_directory",
                                -- fuzzy sorting using the fzy algorithm
                                ["#"] = "fuzzy_sorter",
                                -- ["D"] = "fuzzy_sorter_directory",
                                ["f"] = "filter_on_submit",
                                ["<c-x>"] = "clear_filter",
                                ["[g"] = "prev_git_modified",
                                ["]g"] = "next_git_modified",
                                ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
                                ["oc"] = { "order_by_created", nowait = false },
                                ["od"] = { "order_by_diagnostics", nowait = false },
                                ["og"] = { "order_by_git_status", nowait = false },
                                ["om"] = { "order_by_modified", nowait = false },
                                ["on"] = { "order_by_name", nowait = false },
                                ["os"] = { "order_by_size", nowait = false },
                                ["ot"] = { "order_by_type", nowait = false },
                                -- ['<key>'] = function(state) ... end,
                            },
                            -- define keymaps for filter popup window in fuzzy_finder_mode
                            fuzzy_finder_mappings = {
                                ["<down>"] = "move_cursor_down",
                                ["<C-n>"] = "move_cursor_down",
                                ["<up>"] = "move_cursor_up",
                                ["<C-p>"] = "move_cursor_up",
                                -- ['<key>'] = function(state, scroll_padding) ... end,
                            },
                        },

                        -- Add a custom command or override a global one using the same function name
                        commands = {}
                    },
                })

                -- vim.keymap.set({ "n", "v" }, "<leader>e", ":Neotree reveal<CR>", { silent = true, remap = false })
                vim.keymap.set({ "n", "v" }, "<leader>e", function()
                    if vim.o.filetype == "neo-tree" then
                        vim.fn.execute(":Neotree close")
                    else
                        vim.fn.execute(":Neotree reveal reveal_force_cwd<CR><C-w>l:Neotree reveal reveal_force_cwd<CR>")
                    end
                end)
            end,
        },

        {
            "jansedivy/jai.vim",
            lazy = false,
        },

        {
            "drybalka/tree-climber.nvim",
            lazy = false,
        },

        {
            "xiyaowong/nvim-cursorword",
            lazy = false,
            init = function()
                vim.g.cursorword_min_width = 1
                vim.g.cursorword_max_width = 50
            end,
        },

        {
            "nvim-focus/focus.nvim",
            lazy = false,
            config = function()
                require("focus").setup({
                    enable = true, -- Enable module
                    commands = true, -- Create Focus commands
                    autoresize = {
                        enable = true, -- Enable or disable auto-resizing of splits
                        width = 92, -- Force width for the focused window
                        -- height = 0, -- Force height for the focused window
                        -- minwidth = 92, -- Force minimum width for the unfocused window
                        -- minheight = 0, -- Force minimum height for the unfocused window
                        height_quickfix = 10, -- Set the height of quickfix panel
                    },
                    split = {
                        bufnew = false, -- Create blank buffer for new split windows
                        tmux = false, -- Create tmux splits instead of neovim splits
                    },
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
            },

            {
                "nvim-treesitter/nvim-treesitter-context",
                lazy = false,
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
            },

            {
                "gbprod/yanky.nvim",
                lazy = false,
                config = function()
                    require("yanky").setup({
                        highlight = {
                            on_put = true,
                            on_yank = true,
                            timer = 200,
                        },
                    })
                end
            },

            {
                "mg979/vim-visual-multi",
                lazy = false,
            },

            -- {
                --     "MattesGroeger/vim-bookmarks",
                --     lazy = false,
                --     init = function()
                    --         vim.g.bookmark_save_per_working_dir = 1
                    --         vim.g.bookmark_auto_save = 1
                    --         vim.g.bookmark_sign = "📘"
                    --     end,
                    -- },

                    {
                        "crusj/bookmarks.nvim",
                        keys = {
                            { "<tab><tab>", mode = { "n" } },
                        },
                        branch = "main",
                        lazy = false,
                        dependencies = {
                            { "nvim-tree/nvim-web-devicons" },
                        },
                        config = function()
                            require("bookmarks").setup({
                                -- storage_dir = "",  -- Default path: vim.fn.stdpath("data").."/bookmarks,  if not the default directory, should be absolute path",
                                mappings_enabled = true, -- If the value is false, only valid for global keymaps: toggle、add、delete_on_virt、show_desc
                                keymap = {
                                    toggle = "<tab><tab>", -- Toggle bookmarks(global keymap)
                                    close = "q", -- close bookmarks (buf keymap)
                                    -- add = "\\z", -- Add bookmarks(global keymap)
                                    add = "<A-k>", -- Add bookmarks(global keymap)
                                    -- add_global = "\\g", -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol '󰯾'
                                    -- add_global = "<A-k>", -- Add global bookmarks(global keymap), global bookmarks will appear in all projects. Identified with the symbol '󰯾'
                                    jump = "<CR>", -- Jump from bookmarks(buf keymap)
                                    delete = "dd", -- Delete bookmarks(buf keymap)
                                    order = "<space><space>", -- Order bookmarks by frequency or updated_time(buf keymap)
                                    delete_on_virt = "\\dd", -- Delete bookmark at virt text line(global keymap)
                                    show_desc = "\\sd", -- show bookmark desc(global keymap)
                                    focus_tags = "<c-j>",      -- focus tags window
                                    focus_bookmarks = "<c-k>", -- focus bookmarks window
                                    toogle_focus = "<S-Tab>", -- toggle window focus (tags-window <-> bookmarks-window)
                                },
                                width = 1.00, -- Bookmarks window width:  (0, 1]
                                height = 1.0, -- Bookmarks window height: (0, 1]
                                preview_ratio = 0.45, -- Bookmarks preview window ratio (0, 1]
                                tags_ratio = 0.1, -- Bookmarks tags window ratio
                                -- If true, when saving the current file, if the bookmark line number
                                -- of the current file changes, try to fix it.
                                fix_enable = true,
                                -- Show virt text at the end of bookmarked lines, if it is empty,
                                -- use the description of bookmarks instead. sign_icon = "󰃃",
                                -- if it is not empty, show icon in signColumn.
                                virt_text = "",
                                -- virt_pattern = { "*.go", "*.lua", "*.sh", "*.php", "*.rs" }, -- Show virt text only on matched pattern
                                virt_pattern = { "*" }, -- Show virt text only on matched pattern
                                virt_ignore_pattern = {}, -- Ignore showing virt text on matched pattern, this works after virt_pattern
                                border_style = "single", -- border style: "single", "double", "rounded"
                                hl = {
                                    border = "TelescopeBorder", -- border highlight
                                    cursorline = "guibg=Gray guifg=White", -- cursorline highlight
                                },
                            })
                            require("telescope").load_extension("bookmarks")
                        end,
                    },

                    {
                        "mfussenegger/nvim-lint",
                        lazy = false,
                    },

                    {
                        "editorconfig/editorconfig-vim",
                        lazy = false,
                    },

                    {
                        "ms-jpq/coq_nvim", branch = "coq",
                        lazy = false,
                        init = function()
                            vim.g.coq_settings = {
                                auto_start = "shut-up",
                                limits = {
                                    tokenization_limit = 3000,
                                },
                            }
                        end,
                    },

                    {
                        "VonHeikemen/lsp-zero.nvim",
                        lazy = false,
                        branch = "v1.x",
                        dependencies = {
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
                    },

                    {
                        "cappyzawa/trim.nvim",
                        lazy = false,
                    },

                    {
                        "numToStr/Comment.nvim",
                        lazy = false,
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
                    },

                    {
                        "wsdjeg/vim-fetch",
                        lazy = false,
                    },

                    {
                        "bogado/file-line",
                        lazy = false,
                    },

                    {
                        "stevearc/overseer.nvim",
                        lazy = false,
                        config = function()
                            require("overseer").setup({
                                templates = { "builtin" },
                            })
                        end
                    },

                    {
                        "kylechui/nvim-surround",
                        lazy = false,
                        tag = "v2.1.4", -- Use for stability; omit to use `main` branch for the latest features
                        config = function()
                            require("nvim-surround").setup({
                                -- Configuration here, or leave empty to use defaults
                            })
                        end
                    },

                    {
                        "ellisonleao/gruvbox.nvim",
                        lazy = false,
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
                    },

                    -- {
                        --     "romgrk/barbar.nvim",
                        --     lazy = false,
                        --     init = function()
                            --         vim.g.barbar_auto_setup = false
                            --     end,
                            --     opts = {
                                --         animation = false,
                                --         auto_hide = 1,
                                --         maximum_padding = 1,
                                --         minimum_padding = 1,
                                --         semantic_letters = false,
                                --         highlight_inactive_file_icons = false,
                                --         tabpages = false,
                                --         icons = {
                                    --             -- Configure the base icons on the bufferline.
                                    --             -- Valid options to display the buffer index and -number are `true`, "superscript" and "subscript"
                                    --             buffer_index = false,
                                    --             buffer_number = false,
                                    --             button = "",
                                    --             -- Enables / disables diagnostic symbols
                                    --             diagnostics = {
                                        --                 [vim.diagnostic.severity.ERROR] = { enabled = false, icon = "E" },
                                        --                 [vim.diagnostic.severity.WARN] = { enabled = false },
                                        --                 [vim.diagnostic.severity.INFO] = { enabled = false },
                                        --                 [vim.diagnostic.severity.HINT] = { enabled = false },
                                        --             },
                                        --             gitsigns = {
                                            --                 added = { enabled = false, icon = "+" },
                                            --                 changed = { enabled = false, icon = "~" },
                                            --                 deleted = { enabled = false, icon = "-" },
                                            --             },
                                            --             filetype = {
                                                --                 -- Sets the icon's highlight group.
                                                --                 -- If false, will use nvim-web-devicons colors
                                                --                 custom_colors = false,
                                                --                 -- Requires `nvim-web-devicons` if `true`
                                                --                 enabled = false,
                                                --             },
                                                --             separator = { left = "▎", right = "" },
                                                --             -- If true, add an additional separator at the end of the buffer list
                                                --             separator_at_end = false,
                                                --             -- Configure the icons on the bufferline when modified or pinned.
                                                --             -- Supports all the base icon options.
                                                --             modified = { button = "" },
                                                --             pinned = { button = "●", filename = true },
                                                --             -- Use a preconfigured buffer appearance— can be "default", "powerline", or "slanted"
                                                --             preset = "default",
                                                --             -- Configure the icons on the bufferline based on the visibility of a buffer.
                                                --             -- Supports all the base icon options, plus `modified` and `pinned`.
                                                --             alternate = { filetype = { enabled = false } },
                                                --             current = { buffer_index = false },
                                                --             inactive = { button = "" },
                                                --             visible = { modified = { buffer_number = false } },
                                                --         },
                                                --     },
                                                -- },

                                                {
                                                    "akinsho/bufferline.nvim",
                                                    version = "*",
                                                    lazy = false,
                                                    -- dependencies = "nvim-tree/nvim-web-devicons",
                                                    config = function()
                                                        vim.opt.termguicolors = true
                                                        bufferline = require("bufferline")
                                                        background_color = "#0c1016"
                                                        buffer_color = "#8ec07c"
                                                        buffer_selected_color = "#fabd2f"
                                                        bufferline.setup({
                                                            options = {
                                                                style_preset = {
                                                                    bufferline.style_preset.no_italic,
                                                                    bufferline.style_preset.no_bold
                                                                },
                                                                separator_style = {"", ""},
                                                                show_close_icon = false,
                                                                show_buffer_close_icons = false,
                                                                tab_size = 5,
                                                                buffer_close_icon = '',
                                                                modified_icon = '',
                                                                close_icon = '',
                                                                left_trunc_marker = '',
                                                                right_trunc_marker = '',
                                                            },
                                                            highlights = {
                                                                fill = {
                                                                    -- fg = "white",
                                                                    bg = background_color,
                                                                },
                                                                background = {
                                                                    fg = buffer_color,
                                                                    bg = background_color,
                                                                },
                                                                tab = {
                                                                    -- fg = "white",
                                                                    bg = background_color,
                                                                },
                                                                tab_selected = {
                                                                    -- fg = "#fabd2f",
                                                                    bg = background_color,
                                                                },
                                                                tab_separator = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                tab_separator_selected = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- underline = '<colour-value-here>',
                                                                },
                                                                tab_close = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                close_button = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                close_button_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                close_button_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                buffer_visible = {
                                                                    fg = buffer_color,
                                                                    bg = background_color,
                                                                },
                                                                buffer_selected = {
                                                                    fg = buffer_selected_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                numbers = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                numbers_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                numbers_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                diagnostic = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                diagnostic_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                diagnostic_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                hint = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                hint_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                hint_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                hint_diagnostic = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                hint_diagnostic_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                hint_diagnostic_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                info = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                info_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                info_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                info_diagnostic = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                info_diagnostic_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                info_diagnostic_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                warning = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                warning_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                warning_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                warning_diagnostic = {
                                                                    -- fg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    bg = background_color,
                                                                },
                                                                warning_diagnostic_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                warning_diagnostic_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                error = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                },
                                                                error_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                error_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                error_diagnostic = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                },
                                                                error_diagnostic_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                error_diagnostic_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- sp = '<colour-value-here>',
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                modified = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                modified_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                modified_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                duplicate_selected = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- italic = true,
                                                                },
                                                                duplicate_visible = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- italic = true,
                                                                },
                                                                duplicate = {
                                                                    -- fg = background_color,
                                                                    bg = background_color,
                                                                    -- italic = true,
                                                                },
                                                                separator_selected = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                separator_visible = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                separator = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                indicator_visible = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                indicator_selected = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                pick_selected = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                pick_visible = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                pick = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                    -- bold = true,
                                                                    -- italic = true,
                                                                },
                                                                offset_separator = {
                                                                    fg = background_color,
                                                                    bg = background_color,
                                                                },
                                                                trunc_marker = {
                                                                    -- fg = '<colour-value-here>',
                                                                    bg = background_color,
                                                                }
                                                            },
                                                        })
                                                        local opts = { remap = false, silent = true }
                                                        -- vim.keymap.set("n", "<C-S-T>", ":BufferRestore<CR>", opts)
                                                        -- vim.keymap.set("t", "<C-S-T>", ":BufferRestore<CR>", opts)
                                                        -- vim.keymap.set("n", "<leader>v", select_previous_tab, opts)
                                                        -- vim.keymap.set("n", "<leader>m", select_next_tab, opts)
                                                        vim.keymap.set("n", "<A-v>", ":BufferLineCyclePrev<CR>", opts)
                                                        vim.keymap.set("n", "<A-m>", ":BufferLineCycleNext<CR>", opts)
                                                        vim.keymap.set("n", "<A-S-v>", ":BufferLineMovePrev<CR>", opts)
                                                        vim.keymap.set("n", "<A-S-m>", ":BufferLineMoveNext<CR>", opts)
                                                    end,
                                                },

                                            }

local background_color = "#0c1016"
local buffer_color = "#689d6a"
local buffer_selected_color = "#fabd2f"
local cursor_line_bg_color = "#1c3349"
local comments_fg_color = "#a38a46"
local cursor_word_bg_color = "#10409d"

function update_bufferline()
    local inactive_status_line = vim.api.nvim_get_hl_by_name("StatusLineNC", true)
    local status_line = vim.api.nvim_get_hl_by_name("StatusLine", true)
    local keyword = vim.api.nvim_get_hl_by_name("Keyword", true)
    local type = vim.api.nvim_get_hl_by_name("Type", true)

    function get_fg(aboba)
        if aboba.reverse then
            return aboba.background
        end
        return aboba.foreground
    end

    fg = nil
    -- active_fg = "white"
    -- active_fg = get_fg(keyword)
    active_fg = get_fg(type)
    bg = nil
    if inactive_status_line.reverse then
        fg = inactive_status_line.background
        -- active_fg = status_line.background
        bg = inactive_status_line.foreground
    else
        fg = inactive_status_line.foreground
        -- active_fg = status_line.foreground
        bg = inactive_status_line.background
    end

    vim.api.nvim_set_hl(0, "BufferlineBufferSelected", { fg = active_fg, bg = bg })
    vim.api.nvim_set_hl(0, "BufferlineBufferVisible", { fg = fg, bg = bg })
    vim.api.nvim_set_hl(0, "BufferlineBuffer", { fg = fg, bg = bg })
    vim.fn.execute("hi! link BufferlineBackground StatusLineNC")
    vim.fn.execute("hi! link BufferlineBuffer StatusLineNC")
    vim.fn.execute("hi! link BufferlineBufferVisible StatusLineNC")
    vim.fn.execute("hi! link BufferlineIndicatorSelected StatusLineNC")
    vim.fn.execute("hi! link BufferlineIndicatorVisible StatusLineNC")
    vim.fn.execute("hi! link BufferlineFill StatusLineNC")
    vim.fn.execute("hi! link BufferlineModified StatusLineNC")
    vim.fn.execute("hi! link BufferlineModifiedSelected StatusLineNC")
    vim.fn.execute("hi! link BufferlineModifiedVisible StatusLineNC")
end

return {
    "nvim-treesitter/nvim-treesitter",

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        lazy = false,
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

            local telescope_builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", function()
                vim.g.hulvdan_DisableAnimations()
                vim.fn.execute("Telescope find_files hidden=true")
                vim.g.hulvdan_EnableAnimations()
            end, opts)

            vim.keymap.set("n", "<leader>fn", telescope_builtin.git_files, opts)
            vim.keymap.set("n", "<C-S-f>", function()
                telescope.extensions.live_grep_args.live_grep_args()
            end, opts)
        end,
    },

    {
        "mbbill/undotree",
        lazy = false,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
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
                            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
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
                    commands = {},
                },
            })
            vim.keymap.set({ "n", "v" }, "<leader>e", function()
                if vim.o.filetype == "neo-tree" then
                    vim.fn.execute("Neotree close")
                else
                    vim.api.nvim_input(
                        ":<silent>Neotree reveal reveal_force_cwd<CR><C-w>p:<silent>Neotree reveal reveal_force_cwd<CR>"
                    )
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
        "milkypostman/vim-togglelist",
        lazy = false,
        init = function()
            -- NOTE: <leader>q for toggling quickfix list,
            -- <leader>l for toggling location list
            -- Use vim.g.toggle_list_no_mappings = true for not setting bindings
            vim.g.toggle_list_copen_command = ":bo copen"
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
                    -- colorcolumn = { enable = false, -- Display colorcolumn in the foccused window only list = "+1", -- Set the comma-saperated list for the colorcolumn },
                    signcolumn = false, -- Display signcolumn in the focussed window only
                    winhighlight = true, -- Auto highlighting for focussed/unfocussed windows
                },
            })
        end,
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
                mode = "cursor", -- Line used to calculate context. Choices: "cursor", "topline"
                -- -- Separator between context and content. Should be a single character string, like "-".
                -- -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                -- separator = "-",
                -- zindex = 20, -- The Z-index of the context window
                -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
            vim.fn.execute("hi TreesitterContext guibg=#3c3836")
        end,
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
        end,
    },

    {
        "mg979/vim-visual-multi",
        lazy = false,
    },

    {
        "chentoast/marks.nvim",
        lazy = false,
        config = function()
            require("marks").setup({
                -- whether to map keybinds or not. default true
                default_mappings = false,
                -- which builtin marks to show. default {}
                -- builtin_marks = { ".", "<", ">", "^" },
                builtin_marks = {},
                -- whether movements cycle back to the beginning/end of buffer. default true
                cyclic = true,
                -- whether the shada file is updated after modifying uppercase marks. default false
                force_write_shada = true,
                -- how often (in ms) to redraw signs/recompute mark positions.
                -- higher values will have better performance but may cause visual lag,
                -- while lower values may cause performance penalties. default 150.
                refresh_interval = 250,
                -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
                -- marks, and bookmarks.
                -- can be either a table with all/none of the keys, or a single number, in which case
                -- the priority applies to all marks.
                -- default 10.
                sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
                -- disables mark tracking for specific filetypes. default {}
                excluded_filetypes = {},
                -- disables mark tracking for specific buftypes. default {}
                excluded_buftypes = {},
                -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
                -- sign/virttext. Bookmarks can be used to group together positions and quickly move
                -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
                -- default virt_text is "".
                bookmark_0 = {
                    sign = "⚑",
                    virt_text = "⚑",
                    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
                    -- defaults to false.
                    annotate = false,
                },
                mappings = {
                    next_bookmark0 = "<A-l>",
                    prev_bookmark0 = "<A-j>",
                    toggle_bookmark0 = "<A-k>",
                },
            })
            vim.fn.execute("hi MarkVirtTextHL guibg=" .. background_color .. " guifg=#8ec07c")
        end,
    },

    -- {
    --     "mfussenegger/nvim-lint",
    --     lazy = false,
    -- },

    -- {
    --     "editorconfig/editorconfig-vim",
    --     lazy = false,
    -- },

    {
        "ms-jpq/coq_nvim",
        branch = "coq",
        lazy = false,
        init = function()
            vim.g.coq_settings = {
                auto_start = "shut-up",
                limits = {
                    tokenization_limit = 10000,
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
        end,
    },

    {
        "stevearc/conform.nvim",
        lazy = false,
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    cpp = { "clang-format" },
                    lua = { "stylua" },
                    python = { "isort", "black" },
                    -- Use a sub-list to run only the first available formatter
                    -- javascript = { { "prettierd", "prettier" } },
                },
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function(args)
                    require("conform").format({ bufnr = args.buf })
                end,
            })
        end,
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
        end,
    },

    {
        "wsdjeg/vim-fetch",
        lazy = false,
    },

    -- {
    --     "bogado/file-line",
    --     lazy = false,
    -- },

    {
        "stevearc/overseer.nvim",
        lazy = false,
        config = function()
            require("overseer").setup({
                templates = { "builtin" },
            })
        end,
    },

    {
        "kylechui/nvim-surround",
        lazy = false,
        tag = "v2.1.4", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },

    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     lazy = false,
    --     tag = "v3.5.4",
    --     config = function()
    --         local hooks = require("ibl.hooks")
    --         hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --             vim.api.nvim_set_hl(0, "Indent", { fg = cursor_line_bg_color })
    --         end)
    --         require("ibl").setup({
    --             indent = {
    --                 char = "▎",
    --                 highlight = { "Indent" },
    --             },
    --             scope = {
    --                 enabled = false,
    --                 highlight = { "Indent" },
    --             },
    --         })
    --         hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    --         hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.hide_first_space_indent_level)
    --         hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    --     end,
    -- },

    -- {
    --     "zaldih/themery.nvim",
    --     lazy = false,
    --     config = function()
    --         require("themery").setup({
    --             themes = {
    --                 {
    --                     name = "gruvbox",
    --                     colorscheme = "gruvbox",
    --                     before = [[]],
    --                     after = [[update_bufferline()]],
    --                 },
    --                 -- {
    --                 --     name = "neofusion",
    --                 --     colorscheme = "neofusion",
    --                 -- },
    --                 {
    --                     name = "onedark_dark",
    --                     colorscheme = "onedark_dark",
    --                     after = [[update_bufferline()]],
    --                 },
    --             },
    --             -- themeConfigFile = "~/.config/nvim/lua/settings/theme.lua",
    --             livePreview = true, -- Apply theme while browsing. Default to true.
    --         })
    --     end,
    -- },

    -- {
    --     "diegoulloao/neofusion.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require("neofusion").setup({
    --             terminal_colors = true, -- add neovim terminal colors
    --             undercurl = true,
    --             underline = true,
    --             bold = true,
    --             italic = {
    --                 strings = false,
    --                 emphasis = false,
    --                 comments = false,
    --                 operators = false,
    --                 folds = false,
    --             },
    --             strikethrough = true,
    --             invert_selection = false,
    --             invert_signs = false,
    --             invert_tabline = false,
    --             invert_intend_guides = false,
    --             inverse = true, -- invert background for search, diffs, statuslines and errors
    --             palette_overrides = {},
    --             overrides = {},
    --             dim_inactive = false,
    --             transparent_mode = false,
    --         })
    --     end,
    -- },

    -- {
    --     "olimorris/onedarkpro.nvim",
    --     lazy = false,
    --     config = function()
    --         require("onedarkpro").setup({
    --             colors = {},
    --             highlights = {
    --                 -- Normal = { bg = background_color },
    --                 CursorLine = { bg = cursor_line_bg_color },
    --                 NonText = { fg = background_color },
    --                 EndOfBuffer = { fg = background_color },
    --                 Comment = { fg = comments_fg_color },
    --                 CursorWord = { bg = cursor_word_bg_color },
    --             },
    --         })
    --     end,
    -- },

    {
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        config = function()
            require("colorizer").setup()
        end,
    },

    {
        "Wansmer/langmapper.nvim",
        lazy = false,
        priority = 1,
        config = function()
            require("langmapper").setup({--[[ your config ]]
            })
            require("langmapper").automapping({ global = true, buffer = true })
        end,
    },

    {
        "ellisonleao/gruvbox.nvim",
        version = "2.0.0",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
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
                overrides = {
                    Normal = { bg = background_color },
                    CursorLine = { bg = cursor_line_bg_color },
                    NonText = { fg = background_color },
                    EndOfBuffer = { fg = background_color },
                    Comment = { fg = comments_fg_color },
                    CursorWord = { bg = cursor_word_bg_color },
                },
                -- dim_inactive = true,
                -- transparent_mode = false,
            })
            vim.cmd.colorscheme("gruvbox")
            update_bufferline()
        end,
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        lazy = false,
        priority = 2,
        -- dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            vim.opt.termguicolors = true
            bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    style_preset = {
                        bufferline.style_preset.no_italic,
                        bufferline.style_preset.no_bold,
                    },
                    separator_style = { "", "" },
                    indicator = { style = "none" },
                    show_close_icon = false,
                    show_buffer_close_icons = false,
                    tab_size = 5,
                    buffer_close_icon = "",
                    modified_icon = "",
                    close_icon = "",
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    truncate_names = false,
                    custom_filter = function(buf, buf_nums)
                        return vim.bo[buf].filetype ~= "qf"
                    end,
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
                    },
                },
            })
            local opts = { remap = false, silent = true }

            update_bufferline()

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

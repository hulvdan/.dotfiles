vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- TODO: CHECK ON OTHER DEVICES!
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        -- or                            , branch = '0.1.x',
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "BurntSushi/ripgrep" }, -- Optional
            { "nvim-telescope/telescope-live-grep-args.nvim" }, -- Optional
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
    }

    use("mbbill/undotree")
    use("preservim/nerdtree")

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
                    -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
                    buffer_index = false,
                    buffer_number = false,
                    button = '',
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
    vim.g.bookmark_sign = '📘'
    use("MattesGroeger/vim-bookmarks")
    use("mfussenegger/nvim-lint")

    use("editorconfig/editorconfig-vim")

    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },             -- Required
            { "williamboman/mason.nvim" },           -- Optional
            { "williamboman/mason-lspconfig.nvim" }, -- Optional

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },         -- Required
            { "hrsh7th/cmp-nvim-lsp" },     -- Required
            { "hrsh7th/cmp-buffer" },       -- Optional
            { "hrsh7th/cmp-path" },         -- Optional
            { "saadparwaiz1/cmp_luasnip" }, -- Optional
            { "hrsh7th/cmp-nvim-lua" },     -- Optional

            -- Snippets
            { "L3MON4D3/LuaSnip" },             -- Required
            { "rafamadriz/friendly-snippets" }, -- Optional
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                handlers = {
                    require('lsp-zero').default_setup,
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

    -- vim.keymap.set('n', '<C-/>', api.call('toggle.linewise', 'g@'), { expr = true })
    -- vim.keymap.set('n', '<C-?>', api.call('toggle.linewise.current', 'g@$'), { expr = true })
    -- vim.keymap.set('v', '<C-/>', function() api.call('toggle.linewise', 'g@') end, {remap=false, silent=true})
    -- vim.keymap.set('v', '<C-?>', function() api.call('toggle.linewise.current', 'g@$') end, { expr = true })


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

    use({
        "windwp/nvim-spectre",
        requires = {
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            require("spectre").setup({
                color_devicons = true,
                open_cmd = "vnew",
                live_update = true, -- auto execute search again when you write to any file in vim
                lnum_for_results = true, -- show line number for search/replace results
                line_sep_start = "",
                result_padding = "",
                line_sep       = "",
                highlight = {
                    ui = "String",
                    search = "DiffChange",
                    replace = "DiffDelete"
                },
                mapping = {
                    ["tab"] = {
                        map = "<Tab>",
                        cmd = "<cmd>lua require('spectre').tab()<cr>",
                        desc = "next query"
                    },
                    ["shift-tab"] = {
                        map = "<S-Tab>",
                        cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
                        desc = "previous query"
                    },
                    ["toggle_line"] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "toggle item"
                    },
                    ["enter_file"] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "open file"
                    },
                    ["send_to_qf"] = {
                        map = "<C-S-q>",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix"
                    },
                    ["replace_cmd"] = {
                        map = "<leader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace command"
                    },
                    -- ["show_option_menu"] = {
                    --     map = "<leader>o",
                    --     cmd = "<cmd>lua require('spectre').show_options()<CR>",
                    --     desc = "show options"
                    -- },
                    ["run_current_replace"] = {
                        map = "<leader>rc",
                        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                        desc = "replace current line"
                    },
                    ["run_replace"] = {
                        map = "<leader>R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all"
                    },
                    -- ["change_view_mode"] = {
                    --     map = "<leader>v",
                    --     cmd = "<cmd>lua require('spectre').change_view()<CR>",
                    --     desc = "change result view mode"
                    -- },
                    -- ["change_replace_sed"] = {
                    --     map = "trs",
                    --     cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
                    --     desc = "use sed to replace"
                    -- },
                    -- ["change_replace_oxi"] = {
                    --     map = "tro",
                    --     cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
                    --     desc = "use oxi to replace"
                    -- },
                    -- ["toggle_live_update"]={
                    --     map = "tu",
                    --     cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
                    --     desc = "update when vim writes to file"
                    -- },
                    ["toggle_ignore_case"] = {
                        map = "<A-c>",
                        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                        desc = "toggle ignore case"
                    },
                    ["toggle_ignore_hidden"] = {
                        map = "<A-h>",
                        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                        desc = "toggle search hidden"
                    },
                    ["resume_last_search"] = {
                        map = "<leader>l",
                        cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
                        desc = "repeat last search"
                    },
                    -- you can put your mapping here it only use normal mode
                },
                find_engine = {
                    -- rg is map with finder_cmd
                    ["rg"] = {
                        cmd = "rg",
                        -- default args
                        args = {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                        } ,
                        options = {
                            ["ignore-case"] = {
                                value= "--ignore-case",
                                icon="[I]",
                                desc="ignore case"
                            },
                            ["hidden"] = {
                                value="--hidden",
                                desc="hidden file",
                                icon="[H]"
                            },
                            -- you can put any rg search option you want here it can toggle with
                            -- show_option function
                        }
                    },
                },
                -- replace_engine={
                --     ["sed"]={
                --         cmd = "sed",
                --         args = nil,
                --         options = {
                --             ["whole-words"] = {
                --                 value= "--ignore-case",
                --                 icon="[W]",
                --                 desc="whole words"
                --             },
                --         }
                --     },
                -- },
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
    use {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                -- Main options --
                ---- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                style = 'deep',
                transparent = false,  -- Show/hide background
                term_colors = true, -- Change terminal color as per the selected theme style
                ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- toggle theme style ---
                -- toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
                -- toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

                -- Change code style ---
                -- Options are italic, bold, underline, none
                -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
                code_style = {
                    comments = 'none',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none'
                },

                -- Lualine options --
                lualine = {
                    transparent = false, -- lualine center bar transparency
                },

                -- Custom Highlights --
                colors = {}, -- Override default colors
                highlights = {}, -- Override highlight groups

                -- Plugins Config --
                diagnostics = {
                    darker = true, -- darker colors for diagnostic
                    undercurl = true,   -- use undercurl instead of underline for diagnostics
                    background = true,    -- use background color for virtual text
                },
            })
        end
    }
end)

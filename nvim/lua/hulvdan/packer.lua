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
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
            })
        end
    }
end)

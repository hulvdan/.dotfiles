vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { 'ellisonleao/gruvbox.nvim' }

    -- TODO: CHECK ON OTHER DEVICES!
    require 'nvim-treesitter.install'.prefer_git = false

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('mbbill/undotree')
    use('preservim/nerdtree')

    use('gbprod/yanky.nvim')
    require('yanky').setup({
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 200,
        },
    })

    use('romgrk/barbar.nvim')
    require('barbar').setup({
        animation = false,
        auto_hide = 1,
        icons = {
            -- Configure the base icons on the bufferline.
            -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
            buffer_index = false,
            buffer_number = false,
            button = '',
            -- Enables / disables diagnostic symbols
            diagnostics = {
              [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'E'},
              [vim.diagnostic.severity.WARN] = {enabled = false},
              [vim.diagnostic.severity.INFO] = {enabled = false},
              [vim.diagnostic.severity.HINT] = {enabled = false},
            },
            gitsigns = {
              added = {enabled = false, icon = '+'},
              changed = {enabled = false, icon = '~'},
              deleted = {enabled = false, icon = '-'},
            },
            filetype = {
              -- Sets the icon's highlight group.
              -- If false, will use nvim-web-devicons colors
              custom_colors = false,

              -- Requires `nvim-web-devicons` if `true`
              enabled = false,
            },
            separator = {left = '', right = ''},

            -- If true, add an additional separator at the end of the buffer list
            separator_at_end = true,

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = {button = ''},
            pinned = {button = '●', filename = true},

            -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
            preset = 'default',

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = {filetype = {enabled = false}},
            current = {buffer_index = false},
            inactive = {button = ''},
            visible = {modified = {buffer_number = false}},
        },
    })

    use('gpanders/editorconfig.nvim')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        },
    }

    use { 'numToStr/Comment.nvim' }
    require('Comment').setup({
        toggler = {
            line = "<C-/>",
            block = "<C-?>",
        },
    })

    local api = require('Comment.api')
    vim.keymap.set({'n', 'v'}, '<C-/>', api.call('toggle.linewise', 'g@'), { expr = true })
    vim.keymap.set({'n', 'v'}, '<C-?>', api.call('toggle.linewise.current', 'g@$'), { expr = true })
    -- vim.keymap.set('n', '<C-/>', api.call('toggle.linewise', 'g@'), { expr = true })
    -- vim.keymap.set('n', '<C-?>', api.call('toggle.linewise.current', 'g@$'), { expr = true })
    -- vim.keymap.set('v', '<C-/>', function() api.call('toggle.linewise', 'g@') end, {remap=false, silent=true})
    -- vim.keymap.set('v', '<C-?>', function() api.call('toggle.linewise.current', 'g@$') end, { expr = true })

    require('mason').setup()
    require('mason-lspconfig').setup({
        handlers = {
            require('lsp-zero').default_setup,
        },
    })

    use { 'ThePrimeagen/vim-be-good' }
    require("gruvbox").setup({
        italic = {
            strings = false,
            emphasis = false,
            comments = false,
            operators = false,
            folds = false,
        },
    })
end)


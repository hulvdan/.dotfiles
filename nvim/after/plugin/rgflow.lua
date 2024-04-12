require("rgflow").setup(
    {
        -- Set the default rip grep flags and options for when running a search via
        -- RgFlow. Once changed via the UI, the previous search flags are used for
        -- each subsequent search (until Neovim restarts).
        cmd_flags = "--smart-case --fixed-strings --ignore --max-columns 200",

        -- Mappings to trigger RgFlow functions
        default_trigger_mappings = true,
        -- These mappings are only active when the RgFlow UI (panel) is open
        default_ui_mappings = true,
        -- QuickFix window only mapping
        default_quickfix_mappings = true,
        colors = {
            -- The values map to vim.api.nvim_set_hl {val} parameters, see :h nvim_set_hl
            -- Examples:
            --      RgFlowInputPath    = {fg = "fg", bg="#1234FF", bold=true}
            --      RgFlowInputPattern = {link = "Title"}
            ---- UI
            -- Recommend not setting a BG so it uses the current lines BG
            RgFlowHead          = nil, -- The header colors for FLAGS / PATTERN / PATH blocks
            RgFlowHeadLine      = nil, -- The line along the top of the header
            -- Even though just a background, add the foreground or else when
            -- appending cant see the insert cursor
            RgFlowInputBg       = { fg = "#FFFFFF", bg="#000000" },
            RgFlowInputFlags    = { fg = "#FFFFFF", bg="#000000" },
            RgFlowInputPattern  = { fg = "#FFFFFF", bg="#000000" },
            RgFlowInputPath     = { fg = "#FFFFFF", bg="#000000" },
            ---- Quickfix
            RgFlowQfPattern     = nil, -- The highlighting of the pattern in the quickfix results
        },
    }
)

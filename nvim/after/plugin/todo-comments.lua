-- TODO(Hulvdan): Test it hightlights
--
-- TODO: Test it highlights.
-- And it also highlights a line below
--
-- It should not highlight TODO keyword here
-- It should not highlight TODO keyword here: and here. But now I don't give a shit
-- @TODO: Fix upper thingy
-- It should not highlight TODO keyword here. But now I don't give a shit
-- @TODO: Fix upper thingy
--
-- It should not highlight todo keyword
--
-- It should not highlight NOTE keyword
--
-- It should not highlight note keyword

require("todo-comments").setup({
    signs = false,
    highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "bg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS).*:.*]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 200, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
    },
    colors = {
        -- TODO: Colors
        -- error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        -- warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        -- info = { "DiagnosticInfo", "#2563EB" },
        -- hint = { "DiagnosticHint", "#10B981" },
        -- default = { "Identifier", "#7C3AED" },
        -- test = { "Identifier", "#FF00FF" }
    },
})

-- TODO(Hulvdan): Test it hightlights
--
-- TODO: Test it highlights.
-- And it also highlights a line below
--
-- It should not highlight TODO keyword here
-- It should not highlight TODO keyword here: and here. But now I don't give a shit
-- @TODO: Fix upper thingy
--
-- It should not highlight TODO keyword here: But now I don't give a shit
-- @TODO: Fix upper thingy
--
-- NOTE: Test great color
--
-- FIX: Test great color
--
-- TEST: Test great color
-- PERF: Test great color
-- HACK: Test great color
--
-- It should not highlight todo keywors
--
-- It should not highlight NOTE keyword
--
-- It should not highlight note keyword
--
-- --------- TODO message:
-- -------------------------------

require("todo-comments").setup({
    signs = false,
    highlight = {
        multiline = false, -- enable multine todo comments
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
    keywords = {
        FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "warning" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
})

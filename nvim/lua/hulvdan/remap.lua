-- MY SHORTCUTS --
-- ============ --
vim.fn.execute("set splitright")
vim.g.mapleader = " "
local opts = { remap = false, silent = true }

-- Moving lines updown with Shift-K / Shift-J in the visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

-- The best remap ever
vim.keymap.set("n", "Q", "<nop>", opts)
vim.keymap.set("i", "<f20>", "<nop>", opts)
vim.keymap.set("i", "<f24>", "<nop>", opts)
vim.keymap.set("i", "<f20><space>", " ", opts)
vim.keymap.set("i", "<f24><space>", " ", opts)
vim.keymap.set("n", "<C-l>", "<nop>", opts)
vim.keymap.set({"n", "v"}, "<A-z>", function()
    vim.fn.execute("set wrap!")
end, opts)

-- Binding Ctrl+\ Ctrl+N to ESC makes us able to leave the terminal mode
vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], opts)

-- Binding Git functions
-- Ctrl-Shift-G + l - Opens lazygit
vim.keymap.set("n", "<C-S-g>l", function()
    -- TODO: Make it OS agnostic
    -- TODO: Focus if it's already running (based on the window's title - there's a path displayed)
    vim.fn.system("start /MAX lazygit")
end, opts)

-- Ctrl-Shift-G + l - Opens Github Desktop
vim.keymap.set("n", "<C-S-g>d", function()
    vim.fn.system("github")
end, opts)

-- Skipping blocks of code but making it more convenient for my keyboard setup.
-- Also, in normal mode these jumps don't pollute the jumps list
vim.keymap.set("n", "<C-J>", ":keepjumps norm! }<CR>", opts)
vim.keymap.set("n", "<C-K>", ":keepjumps norm! {<CR>", opts)
vim.keymap.set("n", "<C-S-J>", ":keepjumps norm! )<CR>", opts)
vim.keymap.set("n", "<C-S-K>", ":keepjumps norm! (<CR>", opts)
vim.keymap.set("v", "<C-J>", "}", opts)
vim.keymap.set("v", "<C-K>", "{", opts)
vim.keymap.set("v", "<C-S-J>", ")", opts)
vim.keymap.set("v", "<C-S-K>", "(", opts)

-- vim.keymap.set("n", "<C-A-J", "<C-Down>", {silent = true, noremap = false})
-- vim.keymap.set("n", "<C-A-K", "<C-Up>", {silent = true, noremap = false})
-- vim.keymap.set("n", "<C-S-J", "<C-Down>")
-- vim.keymap.set("n", "<C-S-K", "<C-Up>")
-- vim.keymap.set("n", "<C-J", "<C-Down>")
-- vim.keymap.set("n", "<C-K", "<C-Up>")

function WindowsCount()
    local count = 0
    for _, a in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        count = count + 1
    end
    return count
end

vim.keymap.set({"n", "t"}, "<A-q>", function()
    local count = WindowsCount()

    local bufname = vim.api.nvim_buf_get_name(0)
    local is_term = bufname:find("term://", 1, true) == 1

    local there_is_the_same_term = false;

    -- NVIM BULLSHIET
    if is_term then
        local listed_buffers_count = 1
        local current_buf_number = -1
        for buffer_number = 1, vim.fn.bufnr("$") do
            if vim.fn.buflisted(buffer_number) == 1 then
                local listed_name = vim.api.nvim_buf_get_name(listed_buffers_count)
                if listed_name == bufname then
                    current_buf_number = buffer_number
                end
            end

            listed_buffers_count = listed_buffers_count + 1
        end

        local found = false
        for _, window_number in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local ass_buffer = vim.fn.winbufnr(window_number)
            if ass_buffer == current_buf_number then
                if found then
                    there_is_the_same_term = true
                end

                if not found then
                    found = true
                end
            end
        end
    end
    -- NVIM BULLSHIET END

    if count == 1 or (is_term and not there_is_the_same_term) then
        vim.fn.execute(":bdelete!")
    else
        vim.fn.execute(":q")
    end
end, opts)

vim.keymap.set("n", "<f2>", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<S-f2>", vim.diagnostic.goto_prev, opts)

vim.keymap.set("n", [[<C-\>]], function()
    vim.g.hulvdan_DisableAnimations()
    vim.fn.execute("vs")
    vim.fn.execute("wincmd h")
    vim.g.hulvdan_EnableAnimations()
end, opts)
vim.keymap.set("n", [[<C-|>]], function()
    vim.g.hulvdan_DisableAnimations()
    vim.fn.execute("vs")
    vim.g.hulvdan_EnableAnimations()
end, opts)

-- TELESCOPE --
-- ========= --
local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
vim.keymap.set("n", "<leader>ff", function()
    vim.g.hulvdan_DisableAnimations()
    vim.fn.execute("Telescope find_files hidden=true")
    vim.g.hulvdan_EnableAnimations()
end, opts)

vim.keymap.set("n", "<leader>fn", telescope_builtin.git_files, opts)
vim.keymap.set("n", "<C-S-f>", function()
    telescope.extensions.live_grep_args.live_grep_args()
end, opts)

-- BOOKMARKS --
-- ========= --
vim.keymap.set("n", "<A-j>", function() vim.fn.execute(":BookmarkPrev") end, opts)
vim.keymap.set("n", "<A-l>", function() vim.fn.execute(":BookmarkNext") end, opts)
vim.keymap.set("n", "<A-k>", function() vim.fn.execute(":BookmarkToggle") end, opts)

function OpenNotes()
    local notes_path = [[~/GoogleDrive/Media/Documents/notes.md]]
    vim.fn.execute("e " .. notes_path)
end

vim.keymap.set("n", "<leader>n", OpenNotes, opts)

-- VIM-VISUAL-MULTI --
-- ================ --
vim.keymap.set("n", '<A-J>', '<C-Down>', {silent=true, remap=true})
vim.keymap.set("n", '<A-K>', '<C-Up>', {silent=true, remap=true})

vim.keymap.set("n", "<C-}>", ":cc<CR>:cn<CR>", opts)
vim.keymap.set("n", "<C-{>", ":cc<CR>:cp<CR>", opts)

vim.keymap.set("n", "<M-[>", function()
    require("tree-climber").goto_parent()
end, { silent = true })

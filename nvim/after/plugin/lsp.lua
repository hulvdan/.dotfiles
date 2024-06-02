local lsp = require("lsp-zero")
local coq = require("coq")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr, remap = false, silent = true }

    vim.keymap.set("n", "<S-f6>", vim.lsp.buf.rename, opts)

    vim.keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts)
    vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
    vim.keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)

    for key, value in pairs(vim.lsp.get_active_clients()) do
        lsp[value["name"]].setup(coq.lsp_ensure_capabilities())
    end
end)

lsp.setup({
    "manual-setup",
    manage_nvim_cmp = false,
})

-- TODO: Разломал мануальное подрубление LSP через :LspStart

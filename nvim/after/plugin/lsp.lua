local lsp = require("lsp-zero")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr, remap = false, silent = true }

    vim.keymap.set("n", "<S-f6>", vim.lsp.buf.rename, opts)
end)

lsp.setup({
    "manual-setup",
    manage_nvim_cmp = false,
})

-- TODO: Разломал мануальное подрубление LSP через :LspStart

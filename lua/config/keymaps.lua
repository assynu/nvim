vim.keymap.set("n", "<leader>pv", vim.cmd.Explore)
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
--vim.keymap.set("n", "<leader>i", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>i", function()
    require("conform").format({ async = true })
end)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>a", HarpoonAdd)
vim.keymap.set("n", "<leader>h", HarpoonShow)

vim.keymap.set("n", "<leader>ff", ":Pick files<CR>")
vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>fr", ":Pick resume<CR>")
vim.keymap.set("n", "<leader>fw", ":Pick grep pattern='<cword>'<CR>")

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>")

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  noremap = true,
  silent = true,
  desc = "LSP code action",
})

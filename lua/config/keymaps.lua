vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = "Open file tree" })
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":quit<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>i", vim.lsp.buf.format, { desc = "Format buffer" })

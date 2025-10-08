return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		vim.keymap.set("n", "<leader>gd", ":Git diff | only<CR>")
		vim.keymap.set("n", "<leader>gdf", ":Gdiffsplit<CR>")
		vim.keymap.set("n", "<leader>gds", ":Git diff --staged | only<CR>")

		local Assynu_Fugitive = vim.api.nvim_create_augroup("Assynu_Fugitive", {})
		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = Assynu_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end
			end,
		})
	end,
}

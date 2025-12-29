require("assynu.set")
require("assynu.remap")
require("assynu.lazy_init")

local augroup = vim.api.nvim_create_augroup
local AssynuGroup = augroup("Assynu", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = AssynuGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
	group = AssynuGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>rr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = { focus = false }
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local line = cursor_pos[1] - 1
		local col = cursor_pos[2]

		local diagnostics = vim.diagnostic.get(0, { lnum = line })

		for _, d in ipairs(diagnostics) do
			if col >= d.col and col < d.end_col then
				vim.diagnostic.open_float(nil, opts)
				return
			end
		end
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

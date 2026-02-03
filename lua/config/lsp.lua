vim.lsp.config("*", {})

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

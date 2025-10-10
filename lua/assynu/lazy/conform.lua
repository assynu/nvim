return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>i",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters = {
			stylua = {
				prepend_args = {
					"--column-width",
					"999999",
					"--indent-type",
					"Tabs",
					"--indent-width",
					"4",
				},
			},
			prettier = {
				prepend_args = {
					"--use-tabs",
					"--tab-width",
					"4",
				},
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}

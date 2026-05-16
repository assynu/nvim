vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },
	{ src = "https://github.com/ThePrimeagen/harpoon.git",           version = "harpoon2" },
	{ src = "https://github.com/rose-pine/neovim.git" },
	{ src = "https://github.com/assynu/fivem.nvim.git" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim.git" },
	{ src = "https://github.com/nvim-mini/mini.nvim.git" },
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },
	{ src = "https://github.com/stevearc/conform.nvim.git" },

})

-- Mason
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "stylua" },
}

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

function HarpoonAdd()
	harpoon:list():add()
end

function HarpoonShow()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

-- Fivem
require("fivem-nvim").setup({
	globals = {
		"lib",
		"cache",
		"Core",
		"MySQL",
	},
})

-- Supermaven
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<Tab>",
		clear_suggestion = "<C-]>",
	},
})

-- Mini
require('mini.comment').setup()
require('mini.pick').setup({})
require("mini.completion").setup({
	lsp_completion = {
		source_func = "omnifunc",
		auto_setup = false,
	},
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
	end
})

-- Rose Pine Theme
require("rose-pine").setup({
	extend_background_behind_borders = true,
	styles = {
		bold = true,
		italic = false,
		transparency = true,
	},
})

-- Conform

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		vue = { "prettier" },
	},
	formatters = {
		stylua = {
			prepend_args = {
				"--column-width", "9999",
				"--indent-type", "Tabs",
				"--indent-width", "4",
			},
		},
		prettier = {
			prepend_args = { "--use-tabs", "--tab-width", "4" },
		},
	},
})

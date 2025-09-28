return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("conform").setup({
			formatters_by_ft = {},
		})
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"vue_ls",
				"cssls",
				"gopls",
				"stylua",
			},
			automatic_enable = true,
		})

		vim.lsp.config("*", {})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			root_dir = function(fname)
				local util = require("lspconfig.util")

				local fx_root = util.root_pattern("fxmanifest.lua")(fname)
				if fx_root and fx_root ~= vim.env.HOME then
					return fx_root
				end

				local git_root = util.root_pattern(".git")(fname)
				if git_root and git_root ~= vim.env.HOME then
					return git_root
				end

				return vim.fs.dirname(fname)
			end,
			settings = {
				Lua = {
					telemetry = {
						enable = false,
					},
					runtime = {
						version = "Lua 5.4",
						nonstandardSymbol = {
							"/**/",
							"`",
							"+=",
							"-=",
							"*=",
							"/=",
							"<<=",
							">>=",
							"&=",
							"|=",
							"^=",
						},
						special = {
							["lib.load"] = "require",
						},
						pathStrict = true,
						plugin = vim.fn.stdpath("config") .. "/lua/assynu/lls-plugins/fivem.lua",
					},
					diagnostics = {
						globals = {
							"lib",
							"cache",
							"Core",
							"MySQL",
							"bit",
							"vim",
							"it",
							"describe",
							"before_each",
							"after_each",
						},
					},
					workspace = {
						ignoreDir = {
							".vscode",
							".git",
							".github",
							"dist",
							"stream",
							"node_modules",
							"web",
						},
						library = {
							vim.fn.stdpath("config") .. "/libraries/lua/cfx",
						},
					},
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "4",
						},
					},
				},
			},
			on_init = function(client)
				if not client.config.settings then
					client.config.settings = {}
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
					runtime = {
						version = "Lua 5.4",
						pathStrict = true,
						nonstandardSymbol = { "+=", "-=", "*=", "/=", "<<=", ">>=", "&=", "|=", "^=" },
						plugin = vim.fn.stdpath("config") .. "/lua/assynu/lls-plugins/fivem.lua",
						special = {
							["lib.load"] = "require",
						},
					},
					workspace = {
						ignoreDir = {
							".vscode",
							".git",
							".github",
							"dist",
							"stream",
							"node_modules",
							"web",
						},
						library = {
							vim.fn.stdpath("config") .. "/libraries/lua/cfx",
						},
						checkThirdParty = false,
					},
					diagnostics = {
						globals = {
							"lib",
							"cache",
							"Core",
							"MySQL",
							"bit",
							"vim",
							"it",
							"describe",
							"before_each",
							"after_each",
						},
					},
					telemetry = { enable = false },
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "4",
						},
					},
				})
			end,
		})

		local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
		local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

		vim.lsp.config("ts_ls", {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_plugin_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = { "typescript", "javascript", "vue" },
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})
	end,
}

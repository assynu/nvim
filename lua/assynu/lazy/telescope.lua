return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",

		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},

		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},

	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local themes = require("telescope.themes")
		local sorters = require("telescope.sorters")

		telescope.setup({
			defaults = {
				sorting_strategy = "ascending",
				case_mode = "ignore_case",
				sort_lastused = false,
				path_display = { "truncate" },
			},

			pickers = {
				find_files = {
					hidden = true,

					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						"--hidden",
						"--follow",
					},

					sorter = sorters.empty(),
				},

				live_grep = {
					additional_args = function()
						return { "--sort", "path" }
					end,

					sorter = sorters.empty(),
				},

				buffers = {
					sort_lastused = false,
					ignore_current_buffer = true,
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = false,
					override_file_sorter = false,
					case_mode = "ignore_case",
				},

				["ui-select"] = {
					themes.get_dropdown(),
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (path order)" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (path order)" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Grep word" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(
				themes.get_dropdown({
					previewer = false,
					winblend = 10,
				})
			)
		end, { desc = "Fuzzy search buffer" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search Neovim config" })
	end,
}


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
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "lazygit")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		vim.keymap.set("n", "<leader>fdg", function()
			if vim.fn.executable("fd") ~= 1 then
				vim.notify("fd not found. Install fd for <leader>fdg to work.", vim.log.levels.ERROR)
				return
			end

			vim.ui.input({ prompt = "Directory: " }, function(dir_input)
				if not dir_input or dir_input == "" then
					return
				end

				local cwd = vim.fn.getcwd()
				local pattern = vim.fn.shellescape("*" .. dir_input .. "*")
				local out = vim.fn.systemlist("fd -t d -H -I -g " .. pattern .. " .")
				local results = {}

				for _, p in ipairs(out) do
					local abs = vim.fn.fnamemodify(cwd .. "/" .. p, ":p")
					if vim.fn.isdirectory(abs) == 1 then
						table.insert(results, abs)
					end
				end

				if #results == 0 then
					vim.notify("No directories found", vim.log.levels.WARN)
					return
				end

				if #results == 1 then
					require("telescope.builtin").live_grep({
						search_dirs = { results[1] },
						prompt_title = "Grep in " .. vim.fn.fnamemodify(results[1], ":t"),
					})
					return
				end

				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local sorters = require("telescope.sorters")
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				pickers
					.new({}, {
						prompt_title = "Choose directory",
						finder = finders.new_table({ results = results }),
						sorter = sorters.get_fuzzy_file(),
						attach_mappings = function(prompt_bufnr)
							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()[1]
								actions.close(prompt_bufnr)
								require("telescope.builtin").live_grep({
									search_dirs = { selection },
									prompt_title = "Grep in " .. vim.fn.fnamemodify(selection, ":t"),
								})
							end)
							return true
						end,
					})
					:find()
			end)
		end)

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

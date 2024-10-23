return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                "nvim-telescope/telescope-live-grep-args.nvim" ,
                version = "^1.0.0",
            },
        },
        opts = {
            extensions_list = {"live-grep-args"}
        },
        config = function()
            local telescope = require('telescope')

            telescope.setup({
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = {
                            "rg",
                            "--files",
                            "--.glob",
                            "!{.git/*,.svelte-kit/*,target/*,node_modules/*}",
                            "--path-separator",
                            "/",
                        },
                    },
                },
            })

            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Telescope find git files' })
            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
        end
    }
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "query", "css", "typescript", "javascript", "html", "zig", "go" },
            sync_install = false,
            auto_install = true,

            indent = { enable = true },
            highlight = {
                enable = true
            }
        })
    end
}

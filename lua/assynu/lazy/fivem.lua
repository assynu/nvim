return {
    "assynu/fivem.nvim",

    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },

    event = "BufReadPre *.lua",

    opts = {
        globals = {
            "lib",
            "cache",
            "Core",
            "MySQL",
        },
    },

    config = function(_, opts)
        require("fivem-nvim").setup(opts)
    end,
}

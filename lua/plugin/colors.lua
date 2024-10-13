return {
    "catppuccin/nvim", name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
        })

        vim.cmd.colorscheme "catppuccin"
    end
}

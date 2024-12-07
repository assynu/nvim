return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local customTheme = require("lualine.themes.nightfly")

        require('lualine').setup {
            options = { theme = customTheme }
        }
    end
}

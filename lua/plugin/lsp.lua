return {
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' }
                },
                mapping = cmp.mapping.preset.insert({
                    ['<Tab>'] = {
                        i = cmp.mapping.select_next_item()
                    }
                })
            })
        end
    },
}

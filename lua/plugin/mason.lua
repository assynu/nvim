return {
    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'ts_ls',
                    'jsonls',
                    'tailwindcss',
                    'html',
                    'eslint',
                },
                handlers = {
                    function(server_name)
                        if server_name == 'lua_ls' then
                            require("lspconfig").lua_ls.setup({
                                settings = {
                                    Lua = {
                                        diagnostics = {
                                            globals = { 'vim', 'Core', 'lib', 'cache' }
                                        },
                                        runtime = {
                                            version = "Lua 5.4"
                                        },
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME,
                                                ("%s/lua/libraries/lua/cfx/library"):format(vim.fn.stdpath("config")),
                                            }
                                        },
                                    },
                                },
                                root_dir = function(fname)
                                    return require("lspconfig").util.root_pattern(
                                        'fxmanifest.lua',  -- Add fxmanifest.lua as a root marker
                                        '.git',            -- Check for .git directory as root
                                        'init.lua'         -- Default Lua init file
                                    )(fname)
                                end
                            })
                        else
                            require('lspconfig')[server_name].setup({})
                        end
                    end,
                }
            })
        end
    }
}


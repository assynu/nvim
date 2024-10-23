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
                                on_attach = function(client)
                                    client.server_capabilities.documentFormattingProvider = true
                                    client.server_capabilities.documentRangeFormattingProvider = true
                                end,
                                settings = {
                                    Lua = {
                                        diagnostics = {
                                            globals = { 'vim', 'Core', 'lib', 'cache' }
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
                                                "^="
                                            },
                                        },
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME,
                                                ("%s/lua/libraries/lua/cfx/library"):format(vim.fn.stdpath("config")),
                                            },
                                            ignoreDir = {
                                                ".vscode",
                                                ".git",
                                                ".github",
                                                "node_modules",
                                                "web"
                                            }
                                        },
                                        telemetry = {
                                            enable = false,
                                        },
                                        format = {
                                            enable = true,
                                            defaultConfig = {
                                                indent_style = "space",
                                                indent_size = "4"
                                            },
                                        },
                                    },
                                }
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

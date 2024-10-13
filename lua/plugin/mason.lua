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
                    'emmet_ls',
                    'html',
                    'eslint',
                },
                handlers = {
                    function(server_name)
                        if server_name == 'lua_ls' then
                            require('lspconfig')[server_name].setup({
                                on_init = function(client)
                                    if client.workspace_folders then
                                        local path = client.workspace_folders[1].name
                                        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                                            return
                                        end
                                    end

                                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                        runtime = {
                                            version = "Lua 5.4"
                                        },
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME
                                                "C:/Users/dawid/Documents/LuaExtension/fivem-lls-addon/library",
                                                "/mnt/c/Users/dawid/Documents/LuaExtension/fivem-lls-addon/library"
                                            }
                                        }
                                    })
                                end,
                                settings = {
                                    Lua = {}
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

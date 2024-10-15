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

                                    local config_dir = vim.fn.stdpath("config")

                                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                        runtime = {
                                            version = "Lua 5.4"
                                        },
                                        workspace = {
                                            checkThirdParty = false,
                                            library = {
                                                vim.env.VIMRUNTIME,
                                                config_dir .. "/lua/libraries/lua/cfx/library",
                                                config_dir .. "/lua/libraries/lua/77/library"
                                            }
                                        },
                                        on_set_text = function(uri, text)
                                            local str_find = string.find
                                            local str_sub = string.sub
                                            local str_gmatch = string.gmatch

                                            -- ignore .vscode dir, extension files (i.e. natives), and other meta files
                                            if str_find(uri, '[\\/]%.vscode[\\/]') or str_sub(text, 1, 8) == '---@meta' then return end

                                            -- ignore files using fx asset protection
                                            if str_sub(text, 1, 4) == 'FXAP' then return '' end

                                            local diffs = {}
                                            local count = 0

                                            -- prevent diagnostic errors in fxmanifest.lua and __resource.lua files
                                            if str_find(uri, 'fxmanifest%.lua$') or str_find(uri, '__resource%.lua$') then
                                                count = count + 1
                                                diffs[count] = {
                                                    start = 1,
                                                    finish = 0,
                                                    text = '---@diagnostic disable: undefined-global\n'
                                                }
                                            end

                                            -- prevent diagnostic errors from safe navigation (foo?.bar and foo?[bar])
                                            for safeNav in str_gmatch(text, '()%?[%.%[]+') do
                                                count = count + 1
                                                diffs[count] = {
                                                    start  = safeNav,
                                                    finish = safeNav,
                                                    text   = '',
                                                }
                                            end

                                            -- prevent "need-check-nil" diagnostic when using safe navigation
                                            for pre, whitespace, tableStart, tableName, tableEnd in str_gmatch(text, '([=,;%s])([%s]*)()([_%w]+)()%?[%.%[]+') do
                                                count = count + 1
                                                diffs[count] = {
                                                    start  = tableStart - 1,
                                                    finish = tableEnd - 1,
                                                    text = ('%s(%s or {})'):format(whitespace == '' and pre or '', tableName)
                                                }
                                            end

                                            -- ignore diagnostics for `in` keyword usage like: local a, b in table
                                            for inKeywordStart, inKeywordEnd in str_gmatch(text, 'local%s+[_%w]+[%s,]*[_%w]*%s+in%s+[_%w]+') do
                                                count = count + 1
                                                diffs[count] = {
                                                    start = inKeywordStart,
                                                    finish = inKeywordEnd,
                                                    text = '' -- No actual change, but ignoring the error
                                                }
                                            end

                                            return diffs
                                        end
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


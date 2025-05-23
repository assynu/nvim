return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls"
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        root_dir = function(fname)
                            local util = require("lspconfig.util")

                            local fx_root = util.root_pattern("fxmanifest.lua")(fname)
                            if fx_root and fx_root ~= vim.env.HOME then
                                return fx_root
                            end

                            local git_root = util.root_pattern(".git")(fname)
                            if git_root and git_root ~= vim.env.HOME then
                                return git_root
                            end

                            return util.path.dirname(fname)
                        end,

                        capabilities = capabilities,
                        settings = {
                            Lua = {
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
                                    special = {
                                        ["lib.load"] = "require"
                                    },
                                    pathStrict = true,
                                    plugin = vim.fn.stdpath('config') .. '/lua/assynu/lls-plugins/fivem.lua'
                                },
                                misc = {
                                    parameters = {
                                        "--develop=true"
                                    }
                                },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                },
                                workspace = {
                                    ignoreDir = {
                                        ".vscode",
                                        ".git",
                                        ".github",
                                        "dist",
                                        "stream",
                                        "node_modules",
                                        "web"
                                    },
                                    library = {
                                        [vim.fn.stdpath('config') .. "/libraries/lua/cfx"] = true,
                                    }
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        vim.diagnostic.config({
            virtual_text = {
                prefix = '●',
                spacing = 2,
            },
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
            update_in_insert = true,
        })
    end
}

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
                "lua_ls",
                "ts_ls",
                "harper_ls"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        root_dir = function(fname)
                            local util = require ("lspconfig.util")
                            local root = util.root_pattern(".git", "fxmanifest.lua")(fname)
                            if root and root ~= vim.env.HOME then
                                return root
                            end
                            local root_lua = util.root_pattern 'lua/'(fname) or ''
                            local root_git = util.find_git_ancestor(fname) or ''
                            if root_lua == '' and root_git == '' then
                                return
                            end
                            return #root_lua >= #root_git and root_lua or root_git
                        end,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "Lua 5.4",
                                    pathStrict = true,
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
                                    }
                                },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                    -- disable = { "lowercase-global", "undefined-global" }
                                },
                                workspace = {
                                    ignoreDir = {
                                        ".vscode",
                                        ".git",
                                        ".github",
                                        "node_modules",
                                        "web"
                                    },
                                    library = {
                                        "/home/assynu/libraries/lua/cfx"
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
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}

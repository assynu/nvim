return {
    'stevearc/conform.nvim',
    keys = {
        {
            "<leader>i",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
        }
    },
    opts = {
        formatters_by_ft = {
            javascript = { "prettierd", "prettier", stop_after_first = true },
            javascriptreact = { "prettierd", "prettier", stop_after_first = true },
            typecript = { "prettierd", "prettier", stop_after_first = true },
            typecriptreact = { "prettierd", "prettier", stop_after_first = true },
            css = { "prettierd", "prettier", stop_after_first = true },
        }
    },
}

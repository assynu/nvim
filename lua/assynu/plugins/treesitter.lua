return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "query", "css", "typescript", "javascript", "html", "zig" },
          sync_install = false,
          indent = { enable = true },
      })
  end
 }

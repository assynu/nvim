return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "css", "c_sharp", "typescript", "javascript", "html", "java" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
      })
  end
 }

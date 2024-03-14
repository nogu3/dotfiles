return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {
            "lua",
            "javascript",
            "html",
            "ruby",
            "bash",
            "css",
            "dockerfile",
            "java",
            "json",
            "markdown",
            "python",
            "scala",
            "vue",
            "yaml",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
 }

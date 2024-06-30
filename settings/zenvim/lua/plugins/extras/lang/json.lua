return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "json",
        "json5",
        "JSON with comments",
      })
    end,
  },

  -- HACK one method define
  -- lsp install
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "prettier",
      })
    end,
  },

  -- lsp config
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "jsonls", {})
  --   end,
  -- },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "json", { "prettier" })
    end,
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = Zenvim.list_append_with_nil(opts.linters_by_ft, "json", { "prettier" })
    end,
  },
}

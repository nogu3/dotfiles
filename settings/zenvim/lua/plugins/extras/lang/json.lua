return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "json",
        "jsonc",
      })
    end,
  },

  -- lsp install
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "json-lsp",
      })
    end,
  },

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "jsonls", {})
    end,
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "json", { "jsonls" })
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "jsonc", { "jsonls" })
    end,
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = Zenvim.list_append_with_nil(opts.linters_by_ft, "json", { "jsonls" })
      opts.linters_by_ft = Zenvim.list_append_with_nil(opts.linters_by_ft, "jsonc", { "jsonls" })
    end,
  },
}

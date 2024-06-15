return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "ruby",
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
        "rubocop",
        "solargraph",
      })
    end,
  },

  -- FIXME
  -- lsp config
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function(_, _)
  --     require("lspconfig").solargraph.setup({})
  --   end,
  -- },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "ruby", { "rubocop" })
    end,
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = Zenvim.list_append_with_nil(opts.linters_by_ft, "ruby", { "rubocop" })
    end,
  },
}

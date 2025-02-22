return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "ruby",
      })
      opts.parser = Zenvim.list_extend_with_nil(opts.parser, {
        embedded_template = {
          install_info = {
            url = "https://github.com/tree-sitter/tree-sitter-embedded-template.git",
            files = { "src/parser.c" },
            branch = "main",
          },
        },
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.erb",
        callback = function()
          vim.bo.filetype = "embedded_template"
        end,
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

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "solargraph", {})
    end,
  },

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

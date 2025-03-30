return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "ruby",
        -- for erb
        "html",
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

  -- lsp install
  -- Mason is not needed since execution is done via Docker.

  -- lsp config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "ruby_lsp", {
        cmd = { "ruby-dev-tool", "--lsp" },
        init_options = {
          formatting = true,
        },
      })
    end,
  },

  -- formatter
  -- {
  --   "stevearc/conform.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "ruby", { "docker_rubocop" })
  --     opts.formatters = {
  --       docker_rubocop = {
  --         command = "ruby-dev-tool",
  --         args = {
  --           "--format",
  --           "$FILENAME",
  --         },
  --       },
  --     }
  --   end,
  -- },
  --
  -- linter
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   opts = function(_, opts)
  --     opts.linters_by_ft = Zenvim.list_append_with_nil(opts.linters_by_ft, "ruby", { "docker_rubocop" })
  --   end,
  -- },
}

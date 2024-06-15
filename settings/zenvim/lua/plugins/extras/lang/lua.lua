return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "lua",
      })
    end,
  },

  -- lsp install
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = function(_, opts)
      Zenvim.list_extend_with_nil(opts.ensure_installed, {
        "stylua",
        "lua-language-server",
      })
    end,
  },

  -- lsp config
  -- {
  --   "neovim/nvim-lspconfig",
  --   -- FIXME unuse config, use opts
  --   config = function(_, _)
  --     require("lspconfig").lua_ls.setup({
  --       settings = {
  --         Lua = {
  --           diagnostics = {
  --             globals = { "vim" },
  --           },
  --           workspace = {
  --             library = vim.api.nvim_get_runtime_file("", true),
  --           },
  --           telemetry = {
  --             enable = false,
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },

  -- formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "lua", { "stylua" })
    end,
  },

  -- linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}

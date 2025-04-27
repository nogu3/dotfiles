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
  -- TODO use ruby-lsp. Issue is not search /app/.rubocop.yml
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.formatters_by_ft = Zenvim.list_append_with_nil(opts.formatters_by_ft, "rubocop", {
        cmd = { "ruby-dev-tool", "--rubocop" },
        init_options = {
          formatting = true,
        },
      })
    end,
  },
}

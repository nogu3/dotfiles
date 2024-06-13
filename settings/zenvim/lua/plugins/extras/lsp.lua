return {
  "neovim/nvim-lspconfig",
  config = function(_, _)
    -- FIXME unuse config, use opts
    require("lspconfig").lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    require("lspconfig").solargraph.setup({
      filetype = { "rb" },
    })
  end,
}

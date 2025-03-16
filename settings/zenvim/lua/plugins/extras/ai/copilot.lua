return {
  {
    "github/copilot.vim",
  },
  -- FIXME lazy load when run nvim
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local is_enabled = vim.fn["copilot#Enabled"]()
      table.insert(opts.sections.lualine_x, 2, {
        function()
          if is_enabled then
            return " "
          else
            return ":"
          end
        end,
        color = function()
          if is_enabled then
            return { fg = 255 }
          else
            return { fg = 241 }
          end
        end,
      })
    end,
  },
}

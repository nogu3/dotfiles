return {
  {
    "github/copilot.vim",
  },
  -- FIXME lazy load when run nvim
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   optional = true,
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     require("plenary.async").run(function()
  --       FIXME vim.fn.execute is blocking function.
  --       local result = vim.fn.execute("Copilot status")
  --       return string.find(result, "Ready") ~= nil
  --     end, function(is_enabled_copilot)
  --       table.insert(opts.sections.lualine_x, 2, {
  --         function()
  --           if is_enabled_copilot then
  --             return " "
  --           else
  --             return ":"
  --           end
  --         end,
  --         color = function()
  --           if is_enabled_copilot then
  --             return { fg = 255 }
  --           else
  --             return { fg = 241 }
  --           end
  --         end,
  --       })
  --     end)
  --   end,
  -- },
}

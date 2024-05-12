return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      { "<leader>E", false },
      { "<leader>ge", false },
      { "<leader>be", false },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_gitignored = false,
        },
      },
    },
  },
}

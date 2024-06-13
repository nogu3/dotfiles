return {
  -- colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function(_, _)
      require("rose-pine").setup({
        variant = "moon", -- main, moon, or dawn
        styles = {
          bold = true,
          italic = true,
          transparency = true,
        },
      })

      vim.cmd("colorscheme rose-pine")
    end,
  },

  -- fuzzy-finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      {
        "<leader>?",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Word",
      },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    },
    opts = function()
      return {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
        mappings = {
          n = {
            ["q"] = require("telescope.actions").close,
          },
        },
        },
      }
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["<leader>n"] = { name = "Neovim" },
        ["<leader>b"] = { name = "Buffers" },
      },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- lazygit
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true,
      })

      keymap_silent("n", "<leader><Space>", function()
        lazygit:toggle()
      end, "Lazygit")
    end,
  },
}

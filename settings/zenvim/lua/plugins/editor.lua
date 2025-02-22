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
      {
        "<leader>p",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      { "<leader>,", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      {
        "<leader>.",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Word",
      },
      { "<leader>C", "<cmd>Telescope command_history<cr>", desc = "Find Command History" },
      { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
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
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!**/.git/*",
          },
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extensions = {
          file_browser = {
            initial_mode = "normal",
            hidden = true,
            no_ignore = true,
          },
        },
      }
    end,
  },

  -- filer
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Open file browser" },
    },
    after = "nvim-telescope/telescope.nvim",
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        { "<leader>n", group = "Neovim" },
        { "<leader>b", group = "Buffers" },
        { "<leader>f", group = "File" },
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>w", group = "Window" },
        { "<leader>q", group = "Quit" },
      },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add(opts.defaults)
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
        float_opts = {
          border = "curved",
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },
      })

      -- TODO move to Zenvim
      function _lazygit_toggle()
        lazygit:toggle()
      end

      Zenvim.keymap_silent("n", "<leader><Space>", function()
        lazygit:toggle()
      end, "Lazygit")
    end,
  },
}

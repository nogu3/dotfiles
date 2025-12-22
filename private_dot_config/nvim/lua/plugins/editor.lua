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
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>p", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>,", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>.", "<cmd>FzfLua grep_cword<cr>", desc = "Word" },
      { "<leader>C", "<cmd>FzfLua command_history<cr>", desc = "Find Command History" },
      { "<leader>bb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers" },
      { "<leader>r", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    },
  },

  -- filer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = false,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        group_empty_dirs = false,
      },
      window = {
        position = "float",
        mappings = {
          ["<esc>"] = "close_window",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          local dir = Zenvim.get_relative_path()
          require("neo-tree.command").execute({
            source = "filesystem",
            position = "float",
            dir = dir,
            reveal = true,
            -- 強制的にcwdを合わせる
            reveal_force_cwd = true,
          })
        end,
        { desc = "Neo-tree (show only current dir)" },
      },
    },
  },

  -- {
  --   "nvim-telescope/telescope.nvim",
  --   cmd = "Telescope",
  --   keys = {
  --     {
  --       "<leader>p",
  --       function()
  --         require("telescope.builtin").find_files()
  --       end,
  --       desc = "Find files",
  --     },
  --     { "<leader>,", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  --     {
  --       "<leader>.",
  --       function()
  --         require("telescope.builtin").grep_string()
  --       end,
  --       desc = "Word",
  --     },
  --     { "<leader>C", "<cmd>Telescope command_history<cr>", desc = "Find Command History" },
  --     { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
  --     { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
  --   },
  --   opts = function()
  --     return {
  --       defaults = {
  --         layout_strategy = "horizontal",
  --         layout_config = {
  --           prompt_position = "top",
  --         },
  --         sorting_strategy = "ascending",
  --         mappings = {
  --           n = {
  --             ["q"] = require("telescope.actions").close,
  --           },
  --         },
  --         vimgrep_arguments = {
  --           "rg",
  --           "--color=never",
  --           "--no-heading",
  --           "--with-filename",
  --           "--line-number",
  --           "--column",
  --           "--smart-case",
  --           "--hidden",
  --           "--glob",
  --           "!**/.git/*",
  --         },
  --       },
  --       pickers = {
  --         find_files = {
  --           -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
  --           find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
  --         },
  --       },
  --       extensions = {
  --         file_browser = {
  --           initial_mode = "normal",
  --           hidden = true,
  --           no_ignore = true,
  --         },
  --       },
  --     }
  --   end,
  --   config = function()
  --     require("telescope").load_extension("fzf")
  --   end,
  -- },
  --
  -- {
  --   "nvim-telescope/telescope-fzf-native.nvim",
  --   build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  -- },

  -- filer
  -- {
  --   "nvim-telescope/telescope-file-browser.nvim",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   keys = {
  --     { "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Open file browser" },
  --   },
  --   after = "nvim-telescope/telescope.nvim",
  -- },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
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
      Zenvim.lazygit = Terminal:new({
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
        on_open = function(_)
          vim.defer_fn(function()
            vim.cmd("startinsert")
          end, 100)
        end,
        on_close = function(_)
          require("gitsigns").refresh()
          vim.defer_fn(function()
            vim.cmd("edit")
          end, 100)
        end,
      })

      Zenvim.keymap_silent("n", "<leader><Space>", function()
        Zenvim.lazygit:toggle()
      end, "Lazygit")
    end,
  },

  -- folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    keys = {
      { "zR", "<cmd>lua require('ufo').openAllFolds()<cr>", desc = "Open all folds" },
      { "zM", "<cmd>lua require('ufo').closeAllFolds()<cr>", desc = "Close all folds" },
    },
    opts = {
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    },
    config = true,
  },
}

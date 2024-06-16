return {
  -- parser
  {
    "nvim-treesitter/nvim-treesitter",
    event = Zenvim.event_lazy_file(),
    -- last release is way too old
    version = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      ensure_installed = {},
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    event = Zenvim.event_lazy_file(),
    dependencies = { "williamboman/mason.nvim" },
    keys = {
      { "<leader>nf", "<cmd>ConformInfo<cr>", desc = "Conform" },
      {
        -- Customize or remove this keymap to your liking
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formattters_by_ft = {
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
        quiet = false,
        async = false,
      },
    },
    config = true,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    "williamboman/mason.nvim",
    event = Zenvim.event_lazy_file(),
    keys = {
      { "<leader>nm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
    },
    -- https://github.com/LazyVim/LazyVim/blob/547dc76a12309d4dafc970ae08832140eae51cba/lua/lazyvim/plugins/lsp/init.lua#L218
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = Zenvim.event_lazy_file(),
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    keys = {
      { "<leader>nl", "<cmd>LspInfo<cr>", desc = "LspInfo" },
    },
    opts = {
      -- TODO understand parameter
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = {},
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },

      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      for lsp_name, lsp_settings in pairs(opts.formatters_by_ft) do
        require("lspconfig")[lsp_name].setup(lsp_settings)
      end
    end,
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    -- last release tag is way too old
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        auto_brackets = {},
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
      }
    end,
    config = true,
  },

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  {
    {
      "mfussenegger/nvim-lint",
      event = Zenvim.event_lazy_file(),
      opts = {
        -- Event to trigger linters
        events = { "BufWritePost", "BufReadPost", "InsertLeave" },
        linters_by_ft = {},
      },
      config = function(_, opts)
        require("lint").linters_by_ft = opts.linters_by_ft
      end,
    },
  },

  -- comment
  {
    "echasnovski/mini.comment",
    version = false,
    config = true,
  },
}

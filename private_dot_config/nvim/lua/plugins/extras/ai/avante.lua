return {
  "yetone/avante.nvim",
  enabled = false,
  event = "VeryLazy",
  lazy = false,
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  opts = {
    -- provider is "copilot", "gemini"
    provider = "gemini",
    -- provider is "copilot"
    -- auto_suggestions_provider = "copilot",
    behaviour = {
      -- auto_suggestions = true,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = true,
      support_paste_from_clipboard = true,
    },
    windows = {
      position = "right",
      width = 30,
      sidebar_header = {
        align = "center",
        rounded = false,
      },
      ask = {
        floating = true,
        start_insert = true,
        border = "rounded",
      },
    },
    file_selector = {
      provider = "fzf-lua",
      provider_opts = {},
    },

    -- providers-setting
    providers = {
      copilot = {
        -- model is "gpt-4o", "claude-3.7-sonnet"
        model = "claude-3.5-sonnet",
        language = "ja",
        extra_request_body = {
          max_tokens = 4096,
        },
      },
      gemini = {
        -- see: model names
        -- https://ai.google.dev/gemini-api/docs/models?hl=ja#model-variations
        model = "gemini-3-pro-preview",
        max_tokens = 4096,
      },
    },
  },

  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

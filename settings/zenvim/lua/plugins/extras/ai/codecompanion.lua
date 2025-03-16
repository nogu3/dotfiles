return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>cn", "<cmd>CodeCompanionChat<cr>", desc = "New CodeCompanionChat" },
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanionChat" },
  },
  cmd = {
    "CodeCompanionChat",
    "CodeCompanionContext",
    "CodeCompanionToggle",
    "CodeCompanionClear",
    "CodeCompanionActions",
  },
  opts = {
    adapters = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          streaming = true,
          schema = {
            model = {
              default = "claude-3.7-sonnet",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "copilot",
        slash_commands = {
          ["buffer"] = {
            opts = {
              provider = "telescope",
            },
          },
          ["file"] = {
            opts = {
              provider = "telescope",
            },
          },
          ["help"] = {
            opts = {
              provider = "telescope",
            },
          },
          ["symbols"] = {
            opts = {
              provider = "telescope",
            },
          },
          ["workspace"] = {

            opts = {
              provider = "telescope",
            },
          },
        },
      },
      inline = {
        adapter = "copilot",
      },
      agent = {
        adapter = "copilot",
      },
    },
    opts = {
      language = "Japanese",
    },
  },
}


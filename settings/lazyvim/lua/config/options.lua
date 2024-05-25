-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- not create backup file
opt.backup = false
-- not create swap file
opt.swapfile = false

-- Set up how to show hidden characters
opt.listchars = {
  tab = "»-", -- Show a tab as '»-' on the screen
  trail = "-", -- Show spaces at the end of a line as '-'
  eol = "↲", -- Show the end of a line as '↲'
  extends = "»", -- Show '»' when a line is too long and continues off the screen
  precedes = "«", -- Show '«' when a line starts off the screen
  nbsp = "%", -- Show a space that doesn't break into a new line as '%'
}

-- Turn on the setting to see the hidden characters
vim.wo.list = true

if vim.fn.has("nvim-0.10") == 1 then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

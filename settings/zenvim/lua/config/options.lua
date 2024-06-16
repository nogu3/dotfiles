-- change leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.timeoutlen = 300

-- not create backup file
opt.backup = false
-- not create swap file
opt.swapfile = false
-- confirm when not saved file
opt.confirm = true
-- auto reload when File being edited changed
opt.autoread = true
-- open file when File being edited exist
opt.hidden = true
-- show command on Status line when Command being entered
opt.showcmd = true
-- show mode is off. Because unnessary.
opt.showmode = false
-- tab to space
opt.expandtab = true

-- Strong cursol line
opt.cursorline = true
-- Column of context
opt.scrolloff = 4

-- show line number
opt.number = true
-- Relative line numbers
opt.relativenumber = true
-- convert tabs to spaces
opt.tabstop = 2
-- space count when auto indent
opt.shiftwidth = 2
-- truecolor support
opt.termguicolors = true

-- Search ignore lower or upper when search str contain lower case
opt.ignorecase = true
-- Search case sensitive when search str contain upper case
opt.smartcase = true

-- Confirm to save changes before exiting modified buffer
opt.confirm = true

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

vim.o.clipboard = "unnamedplus"

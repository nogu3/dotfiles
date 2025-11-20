-- change leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- disabled language provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

-- show diagnostic
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

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
-- splitright is default
opt.splitright = true

-- fold
-- Enable folding functionality
opt.foldenable = true
-- Set fold column width to 1 character
opt.foldcolumn = "1"
-- Set maximum fold level to 99 (essentially unfolds everything)
opt.foldlevel = 99
-- Start editing with all folds open (level 99)
opt.foldlevelstart = 99

-- Strong cursol line
opt.cursorline = true
-- Column of context
opt.scrolloff = 4

-- show line number
opt.number = true
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

vim.o.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

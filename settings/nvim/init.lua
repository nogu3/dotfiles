local opt = vim.opt
-- change leader key
vim.api.nvim_set_keymap('n', '<Space>', '', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- show line number
opt.number=true
-- auto indent when new line
opt.autoindent=true
-- convert tabs to spaces
opt.tabstop=2

require("plugin_manager")
require("keymap")


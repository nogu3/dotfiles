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
-- set Truecolor for bufferline
opt.termguicolors = true

require("plugin_manager")
require("keymap")

-- set colorscheme
vim.cmd [[
try
  colorscheme iceberg
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

-- ale
vim.g.ale_disable_lsp = 1
vim.g.ale_lint_on_text_changed = 0
vim.g.ale_lint_on_save = 1
vim.g.ale_fix_on_save = 0
vim.g.ale_fixers = {
  ['*'] = { "remove_trailing_lines", "trim_whitespace" },
  ['ruby'] = {'rubocop'}
}

local opt = vim.opt

-- change leader key
vim.api.nvim_set_keymap('n', '<Space>', '', {noremap = true, silent = true})
vim.g.mapleader = ' '

-- show environment dependent characters
-- opt.ambiwidth='double'

-- not create backup file
opt.backup = false
-- not create swap file
opt.swapfile = false
-- auto reload when File being edited changed
opt.autoread = true
-- open file when File being edited exist
opt.hidden = true
-- show command on Status line when Command being entered 
opt.showcmd = true
-- tab to space
opt.expandtab = true

-- Strong cursol line
opt.cursorline = true

-- show line number
opt.number=true
-- convert tabs to spaces
opt.tabstop = 4
-- space count when auto indent
opt.shiftwidth = 4
-- set Truecolor for bufferline
opt.termguicolors = true

-- Search ignore lower or upper when search str contain lower case
opt.ignorecase = true
-- Search case sensitive when search str contain upper case
opt.smartcase = true

-- Set up how to show hidden characters
opt.listchars = {
  tab = '»-',     -- Show a tab as '»-' on the screen
  trail = '-',    -- Show spaces at the end of a line as '-'
  eol = '↲',      -- Show the end of a line as '↲'
  extends = '»',  -- Show '»' when a line is too long and continues off the screen
  precedes = '«', -- Show '«' when a line starts off the screen
  nbsp = '%',     -- Show a space that doesn't break into a new line as '%'
}

-- Turn on the setting to see the hidden characters
vim.wo.list = true

-- Create an autocommand that triggers on the FileType event when the 'ruby' filetype is detected
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    -- Set local settings for indentation and tab display
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end
})

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

opt.clipboard = "unnamedplus"

-- windows wsl only settings 
-- but if you write if vim.fn.has("win64") == 1 then , system cant use clipboard.
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf"
    },
  paste = {
    ["+"] = "win32yank.exe -o --crlf",
    ["*"] = "win32yank.exe -o --crlf"
    },
  cache_enable = 0,
  }
end

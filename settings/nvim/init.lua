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

-- keymap
-- autocomplete enter 
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR>"', {noremap = true, silent = true, expr = true})
-- jj to esc
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true, silent = true})

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- plugin setup
require("lazy").setup("plugins", {
  performance = {
      rtp = {
        disabled_plugins = {
           "netrw",
           "netrwPlugin",
           "netrwSettings",
           "netrwFileHandlers",
        },
     },
  },
})

-- telescope
local builtin = require('telescope.builtin')
-- find file
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- grep file
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})


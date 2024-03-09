-- load plugins
-- lazy.nvim setup
local opt = vim.opt
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
require('telescope').setup({
  defaults = {
    file_ignore_patterns = { "%.git/", "node_modules/" }
  },
})


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
local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
  defaults = {
  -- `hidden = true` is not supported in text grep commands.
  vimgrep_arguments = vimgrep_arguments,
  },
  pickers = {
    find_files = {
    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})
-- setup fzf
require('telescope').load_extension('fzf')

-- bufferline
require("bufferline").setup()

-- lualine
require('lualine').setup()

-- marks
require('marks').setup()

-- comment
require('Comment').setup({
    toggler = {
        ---Line-comment toggle keymap
        line = '<leader>c',
    },
})

-- endwise
require('nvim-treesitter.configs').setup {
    endwise = {
        enable = true,
    },
}


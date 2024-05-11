-- keymaps are automatically loaded on the verylazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local function silent(desc)
  return {
    silent = true,
    noremap = true,
    desc = desc,
  }
end

-- mark
map("n", "cm", "y'm<cr><esc>", silent("Copy to mark"))
map("n", "dm", "d'm<cr><esc>", silent("Delete to mark"))

-- open github url
map("n", "<leader>go", ":OpenInGHFile<cr>", silent("Open github url to current file"))
map("n", "<leader>gl", ":OpenInGHFileLines<cr>", silent("Open github url to current file with line"))

-- copy relative file path
map("n", "<leader>fp", ":let @+ = expand('%')<cr>", silent("Copy relative file path"))

-- save
map({ "x", "n", "s" }, "<leader>cs", "<cmd>w<cr><esc>", silent("Save File"))

-- select all
map("n", "<leader>a", "gg<S-v>G", silent("Select All"))

-- buffer
map("n", "<S-j>", ":bprev<cr>", silent("Prev Buffer"))
map("n", "<S-l>", ":bnext<cr>", silent("Next Buffer"))
map("n", "<leader>ba", ":%bd<cr>", silent("Delete All Buffers"))

-- nvim
-- checkhealth
map("n", "<leader>nc", ":checkhealth<cr>", silent("Checkhealth"))
-- reload config
map("n", "<leader>ns", ":source %<cr>", silent("Reload config"))

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

-- general
-- mark
map("n", "cm", "y'm<cr><esc>", silent("Copy to mark"))
map("n", "dm", "d'm<cr><esc>", silent("Delete to mark"))

-- select all
map("n", "<leader>a", "gg<S-v>G", silent("Select All"))

-- buffer
map("n", "<S-j>", ":bprev<cr>", silent("Prev Buffer"))
map("n", "<S-l>", ":bnext<cr>", silent("Next Buffer"))
map("n", "<leader>ba", ":%bd<cr>", silent("Delete All Buffers"))

-- git
-- open github url
map("n", "<leader>go", ":OpenInGHFile<cr>", silent("Open github url to current file"))
map("n", "<leader>gl", ":OpenInGHFileLines<cr>", silent("Open github url to current file with line"))

-- file
-- copy relative file path
map("n", "<leader>fp", ":let @+ = expand('%:.')<cr>", silent("Copy relative file path"))

-- code
-- save
map({ "x", "n", "s" }, "<leader>cs", "<cmd>w<cr><esc>", silent("Save File"))

-- nvim
-- checkhealth
map("n", "<leader>nc", ":checkhealth<cr>", silent("Checkhealth"))

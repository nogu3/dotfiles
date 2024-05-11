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

-- save
map({ "x", "n", "s" }, "<leader>cs", "<cmd>w<cr><esc>", silent("Save File"))

-- select all
map("n", "<leader>a", "gg<S-v>G", silent("Select All"))

-- control buffer
map("n", "<leader>k", ":bnext<cr>", silent("Next Buffer"))
map("n", "<leader>j", ":bprev<cr>", silent("Previous Buffer"))
map("n", "<leader>x", ":bw<cr>", silent("Quit Buffer"))
map("n", "<leader>xx", ":bw!<cr>", silent("Force Quit Buffer"))
map("n", "<leader>ax", ":%bd<cr>", silent("All Quit Buffer"))

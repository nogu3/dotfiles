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

-- delete default keymap from LazyVim
-- delete flash
vim.keymap.del("n", "s")

-- mark
map("n", "<leader>cm", "y'm<cr><esc>", silent("Copy as mark"))
map("n", "<leader>dm", "d'm<cr><esc>", silent("Delete as mark"))

-- save
map({ "x", "n", "s" }, "<leader>cs", "<cmd>w<cr><esc>", silent("Save File"))

-- select all
map("n", "<leader>a", "gg<S-v>G", silent("Select All"))

-- esc
map("i", "jj", "<Esc>", silent("Quit insert mode"))

-- control buffer
map("n", "<leader>k", ":bnext<CR>", silent("Next Buffer"))
map("n", "<leader>j", ":bprev<CR>", silent("Previous Buffer"))
map("n", "<leader>x", ":bw<CR>", silent("Quit Buffer"))
map("n", "<leader>xx", ":bw!<CR>", silent("Force Quit Buffer"))
map("n", "<leader>ax", ":%bd<CR>", silent("All Quit Buffer"))

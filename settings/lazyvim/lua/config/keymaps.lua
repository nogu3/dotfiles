-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keyset = vim.keymap.set
local silent = { silent = true, noremap = true }

-- copy current to mark
keyset("n", "cm", "y'm<CR>")
-- delete current to mark
keyset("n", "dm", "d'm<CR>")
-- save
keyset("n", "<leader>s", ":w<CR>", silent)

-- select all
keyset("n", "<leader>a", "gg<S-v>G", silent)

-- esc
keyset("i", "jj", "<Esc>")

-- control buffer
keyset("n", "<leader>k", ":bnext<CR>", silent)
keyset("n", "<leader>j", ":bprev<CR>", silent)
keyset("n", "<leader>x", ":bw<CR>", silent)
keyset("n", "<leader>xx", ":bw!<CR>", silent)
keyset("n", "<leader>ax", ":%bd<CR>", silent)
-- create empty file
keyset("n", "<leader>n", ":tabnew<CR>", silent)

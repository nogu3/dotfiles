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

-- text edit
-- mark
map("n", "cm", "y'm<Return><Esc>", silent("Copy to mark"))
map("n", "dm", "d'm<Return><Esc>", silent("Delete to mark"))

-- select all copy
map("n", "<leader>a", "gg<S-v>Gy", silent("Select all and Copy"))

-- copy line without yank
map("n", "t", ":t.<Return>", silent("Copy line without yank"))

-- delete line without yank
map("n", "T", '"_dd', silent("Delete line without yank"))

if vim.fn.has("mac") == 1 then
  map("n", "<C-a>", "^", silent("Move to start char"))
  map("n", "<C-e>", "$", silent("Move to end char"))
else
  map("n", "<home>", "^", silent("Move to start char"))
end

-- file
-- buffer
map("n", "<S-j>", ":bprev<Return>", silent("Prev Buffer"))
map("n", "<S-l>", ":bnext<Return>", silent("Next Buffer"))
map("n", "<leader>ba", ":%bd<Return>", silent("Delete All Buffers"))

-- git
-- open github url
map("n", "<leader>go", ":OpenInGHFile<Return>", silent("Open github url to current file"))
map("n", "<leader>gl", ":OpenInGHFileLines<Return>", silent("Open github url to current file with line"))

-- file
-- copy relative file path
map("n", "<leader>fp", ":let @+ = expand('%:.')<Return>", silent("Copy relative file path"))

-- code
-- save
map({ "x", "n", "s" }, "<leader>cs", "<cmd>w<Return><Esc>", silent("Save File"))

-- nvim
-- checkhealth
map("n", "<leader>nc", ":checkhealth<Return>", silent("Checkhealth"))

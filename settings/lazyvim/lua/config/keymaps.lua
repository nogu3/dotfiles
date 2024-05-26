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

local function silent_expr(desc)
  local silent_option = silent(desc)
  silent_option["expr"] = true
  return silent_option
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

-- move indent like vscode
map("n", "<C-[>", "<<", silent("Back Indent"))
map("n", "<C-]>", ">>", silent("Go Indent"))

-- comment line like vscode
local keys = { "<C-/>", "<C-_>" }

-- 配列の内容を出力
for _, key in ipairs(keys) do
  -- https://www.reddit.com/r/neovim/comments/1b7kjm4/lazyvim_how_to_remove_a_keybinding/
  vim.keymap.del("n", key)
  map("n", key, function()
    -- https://github.com/echasnovski/mini.comment/blob/081bf6876eedaeffd85544752f82c18454694238/lua/mini/comment.lua#L442
    return MiniComment.operator() .. "_"
  end, silent_expr("Comment line"))
end

-- move start or end
if vim.fn.has("mac") == 1 then
  map("n", "<C-a>", "^", silent("Move to start char"))
  map("n", "<C-e>", "$", silent("Move to end char"))
else
  map("n", "<home>", "^", silent("Move to start char"))
end

-- file
-- buffer
map("n", "<C-p>", ":bprev<Return>", silent("Prev Buffer"))
map("n", "<C-n>", ":bnext<Return>", silent("Next Buffer"))
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

-- quit
Zenvim.keymap_silent("n", "<leader>qq", "<cmd>q!<cr>", "Quit All")

-- checkhealth
Zenvim.keymap_silent("n", "<leader>nc", "<cmd>checkhealth<cr>", "Checkhealth")

-- lazy
Zenvim.keymap_silent("n", "<leader>nL", "<cmd>Lazy<cr>", "Lazy.nvim")

-- text edit
-- mark
Zenvim.keymap_silent("n", "cm", "y'm<Return><Esc>", "Copy to mark")
Zenvim.keymap_silent("n", "dm", "d'm<Return><Esc>", "Delete to mark")

-- window
Zenvim.keymap_silent("n", "<C-i>", "<C-w>k", "Move window to Up")
Zenvim.keymap_silent("n", "<C-j>", "<C-w>h", "Move window to Left")
Zenvim.keymap_silent("n", "<C-k>", "<C-w>j", "Move window to Down")
Zenvim.keymap_silent("n", "<C-l>", "<C-w>l", "Move window to Right")

-- select all copy
Zenvim.keymap_silent("n", "<leader>a", "gg<S-v>Gy", "Select all and Copy")
-- select all delete
Zenvim.keymap_silent("n", "<leader>A", "gg<S-v>Gd", "Select all and Delete")

-- redo
Zenvim.keymap_silent("n", "U", "<C-r>", "Redo")

-- delete without yank
Zenvim.keymap_silent("n", "x", '"_x', "Delete")

-- FIXME Not Working
-- move start or end
if vim.fn.has("mac") == 1 then
  Zenvim.keymap_silent({ "n", "v" }, "<C-a>", "^", "Move to start char")
  Zenvim.keymap_silent({ "i" }, "<C-a>", "<C-o>^", "Move to start char")

  Zenvim.keymap_silent({ "n", "v" }, "<C-e>", "$", "Move to end char")
  Zenvim.keymap_silent({ "i" }, "<C-e>", "<C-o>$", "Move to end char")
else
  Zenvim.keymap_silent({ "n", "v" }, "<home>", "^", "Move to start char")
  Zenvim.keymap_silent({ "i" }, "<home>", "<C-o>^", "Move to start char")
end

-- file
-- copy relative file path
Zenvim.keymap_silent("n", "<leader>fp", ":let @+ = expand('%:.')<Return>", "Copy relative file path")

-- new file
Zenvim.keymap_silent("n", "<leader>N", "<cmd>enew<cr>", "New File")

-- save file
Zenvim.keymap_silent({ "x", "n", "s" }, "<leader>s", "<cmd>w<cr><esc>", "Save File")

-- git
-- copy github url to clipboard
Zenvim.keymap_silent("n", "<leader>gl", function()
  require("plenary.async").run(function()
    local relative_path = Zenvim.get_relative_path()
    local line_number = Zenvim.get_line_number_on_cursol()
    return vim.fn.system("ghurl " .. relative_path .. " " .. line_number)
  end, function(url)
    vim.fn.setreg("+", url)
    print("Copy github url to clipboard")
  end)
end, "Copy github url to clipboard")

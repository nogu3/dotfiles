-- quit
Zenvim.keymap_silent("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")

-- checkhealth
Zenvim.keymap_silent("n", "<leader>nc", "<cmd>checkhealth<cr>", "Checkhealth")

-- lazy
Zenvim.keymap_silent("n", "<leader>nL", "<cmd>Lazy<cr>", "Lazy.nvim")

-- text edit
-- mark
Zenvim.keymap_silent("n", "cm", function()
  vim.cmd("normal y'm")
  vim.api.nvim_buf_del_mark(0, "m")
end, "Copy to mark")
Zenvim.keymap_silent("n", "dm", "d'm<Return><Esc>", "Delete to mark")

-- multi cursol
Zenvim.keymap_silent("x", "<leader>r", 'y:%s/<C-r><C-r>"//g<Left><Left>', "Change select cursol charactor")
Zenvim.keymap_silent("n", "<leader>*", "*''cgn<C-r><C-r>\"", "Change under cursol charactor")
Zenvim.keymap_silent("n", "<leader>fr", function()
  Zenvim.replace_word_under_cursor()
end, "Replace word under cursol")

Zenvim.keymap_silent("n", "<leader>ff", function()
  Zenvim.input_and_run_vim_command("Set File Type", "set filetype=%s")
end, "Set file type")

-- window
-- move
Zenvim.keymap_silent("n", "<C-i>", "<C-w>k", "Move window to Up")
Zenvim.keymap_silent("n", "<C-j>", "<C-w>h", "Move window to Left")
Zenvim.keymap_silent("n", "<C-k>", "<C-w>j", "Move window to Down")
Zenvim.keymap_silent("n", "<C-l>", "<C-w>l", "Move window to Right")

-- create
Zenvim.keymap_silent("n", "<leader>-", "<C-W>s", "Split Window Below")
Zenvim.keymap_silent("n", "<leader>\\", "<C-W>v", "Split Window Right")

-- delete
Zenvim.keymap_silent("n", "<leader>wd", "<C-W>c", "Delete Window")

-- select all copy
Zenvim.keymap_silent("n", "<leader>a", "gg<S-v>Gy", "Select all and Copy")
-- select all delete
Zenvim.keymap_silent("n", "<leader>A", "gg<S-v>Gd", "Select all and Delete")

-- redo
Zenvim.keymap_silent("n", "U", "<C-r>", "Redo")

-- delete without yank
Zenvim.keymap_silent("n", "x", '"_x', "Delete")

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
Zenvim.keymap_silent("n", "<leader>fp", function()
  local relative_path = Zenvim.get_relative_path()
  Zenvim.set_register_with_print_message("+", relative_path, "Copy relative file path to clipboard")
end, "Copy relative file path")

-- new file
Zenvim.keymap_silent("n", "<leader>fn", "<cmd>enew<cr>", "New File")

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
    Zenvim.set_register_with_print_message("+", url, "Copy github url to clipboard")
  end)
end, "Copy github url to clipboard")

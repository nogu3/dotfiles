-- quit
keymap_silent("n", "<leader>qq", "<cmd>q!<cr>", "Quit All")

-- save file
keymap_silent({ "x", "n", "s" }, "<leader>s", "<cmd>w<cr><esc>", "Save File")

-- checkhealth
keymap_silent("n", "<leader>nc", "<cmd>checkhealth<cr>", "Checkhealth")

-- lazy
keymap_silent("n", "<leader>nL", "<cmd>Lazy<cr>", "Lazy.nvim")

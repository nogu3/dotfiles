-- keymap
-- autocomplete enter
vim.keymap.set('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR>"', {expr = true})

-- copy current to mark
vim.keymap.set("n", "cm", "y'm<CR>")
-- delete current to mark
vim.keymap.set("n", "dm", "d'm<CR>")

-- esc
vim.keymap.set('i', 'jj', '<Esc>')

-- control buffer
vim.keymap.set("n", "<leader>k", ":bnext<CR>")
vim.keymap.set("n", "<leader>j", ":bprev<CR>")
vim.keymap.set("n", "<leader>x", ":bw<CR>")
vim.keymap.set("n", "<leader>xx", ":bw!<CR>")
vim.keymap.set("n", "<leader>ax", ":%bd<CR>")
-- create empty file
vim.keymap.set("n", "<leader>n", ":tabnew<CR>")

-- copy clipboard relative file path
vim.keymap.set("n", "<leader>fp", ":let @+ = expand('%')<CR>")


-- telescope
local builtin = require('telescope.builtin')
-- find file
vim.keymap.set('n', '<leader>p', builtin.find_files)
-- grep file
vim.keymap.set('n', '<leader>ff', builtin.live_grep)

-- telescope file browser
require("telescope").load_extension "file_browser"
-- show file browser
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>")
-- search config dir
vim.keymap.set('n', '<leader>nv', ":Telescope find_files cwd=~/.config/nvim<CR>")

-- toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    hidden = true
})

-- lazygit
function _lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>")

-- ale
vim.keymap.set("n", "<leader>ft", ":ALEFix<CR>")

-- coc.nvim_set_keymap
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)')

-- OpenGithubFile
vim.keymap.set('n', '<leader>og', ':OpenGithubFile<CR>)')


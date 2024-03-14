-- keymap
local opts = { noremap = true, silent = true }
-- autocomplete enter
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR>"', {noremap = true, silent = true, expr = true})

-- copy current to mark
vim.keymap.set("n", "cm", "y'm", opts)
-- delete current to mark
vim.keymap.set("n", "dm", "d'm", opts)

-- esc
vim.keymap.set('i', 'jj', '<Esc>', opts)

-- control buffer
vim.keymap.set("n", "<leader>k", ":bnext<CR>", opts)
vim.keymap.set("n", "<leader>j", ":bprev<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bw<CR>", opts)
vim.keymap.set("n", "<leader>xx", ":bw!<CR>", opts)
vim.keymap.set("n", "<leader>ax", ":%bd<CR>", opts)
-- create empty file
vim.keymap.set("n", "<leader>n", ":tabnew<CR>", opts)

-- copy clipboard relative file path
vim.keymap.set("n", "<leader>fp", ":let @+ = expand('%')<CR>", opts)


-- telescope
local builtin = require('telescope.builtin')
-- find file
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
-- grep file
vim.keymap.set('n', '<leader>ff', builtin.live_grep, {})


-- telescope file browser
require("telescope").load_extension "file_browser"
-- show file browser
vim.keymap.set('n', '<leader>fb', ":Telescope file_browser<CR>" , { noremap = true })
-- search config dir
vim.keymap.set('n', '<leader>nv', ":Telescope find_files cwd=~/.config/nvim<CR>" , { noremap = true })


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

vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", opts)


-- ale
vim.keymap.set("n", "<leader>ft", ":ALEFix<CR>", opts)


-- coc.nvim_set_keymap
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', {noremap = true, silent = true})

-- OpenGithubFile
vim.keymap.set('n', '<leader>og', ':OpenGithubFile<CR>)', {noremap = true, silent = true})

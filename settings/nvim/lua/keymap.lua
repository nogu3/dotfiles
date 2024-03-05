-- keymap
-- autocomplete enter 
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR>"', {noremap = true, silent = true, expr = true})
-- jj to esc
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true, silent = true})

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

-- toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true
})

function _lazygit_toggle()
	lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

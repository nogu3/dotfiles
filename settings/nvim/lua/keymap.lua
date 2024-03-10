-- keymap
local opts = { noremap = true, silent = true }
-- autocomplete enter
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-g>u<CR>"', {noremap = true, silent = true, expr = true})
-- esc
vim.keymap.set('i', 'jj', '<Esc>', opts)
-- move buffer
vim.keymap.set("n", "<C-n>", ":bnext<Return>", opts)
vim.keymap.set("n", "<C-p>", ":bprev<Return>", opts)

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

-- lazygit
function _lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", opts)

-- ale
vim.keymap.set("n", "<leader>ft", ":ALEFix<CR>", opts)


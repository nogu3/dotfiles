-- keymap
local keyset = vim.keymap.set
-- autocomplete enter
keyset('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', {expr = true})
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<Down>", 'coc#pum#visible() ? coc#pum#next(1) : "<Down>"', opts)
keyset("i", "<Up>", 'coc#pum#visible() ? coc#pum#prev(1) : "<Up>"', opts)
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- copy current to mark
keyset("n", "cm", "y'm<CR>")
-- delete current to mark
keyset("n", "dm", "d'm<CR>")

-- esc
keyset('i', 'jj', '<Esc>')

-- control buffer
keyset("n", "<leader>k", ":bnext<CR>")
keyset("n", "<leader>j", ":bprev<CR>")
keyset("n", "<leader>x", ":bw<CR>")
keyset("n", "<leader>xx", ":bw!<CR>")
keyset("n", "<leader>ax", ":%bd<CR>")
-- create empty file
keyset("n", "<leader>n", ":tabnew<CR>")

-- copy clipboard relative file path
keyset("n", "<leader>fp", ":let @+ = expand('%')<CR>")

-- telescope
local builtin = require('telescope.builtin')
-- find file
keyset('n', '<leader>p', builtin.find_files)
-- grep file
keyset('n', '<leader>ff', builtin.live_grep)

-- telescope file browser
require("telescope").load_extension "file_browser"
-- show file browser
keyset('n', '<leader>fb', ":Telescope file_browser<CR>")
-- search config dir
keyset('n', '<leader>nv', ":Telescope find_files cwd=~/.config/nvim<CR>")

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

keyset("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>")

-- ale
keyset("n", "<leader>ft", ":ALEFix<CR>")

-- coc.nvim_set_keymap
keyset('n', 'gd', '<Plug>(coc-definition)')

-- OpenGithubFile
keyset('n', '<leader>og', ':OpenGithubFile<CR>)')


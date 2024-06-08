-- default keymaps
local map = vim.keymap.set
local delmap = vim.keymap.del

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

-- quit
map("n", "<leader>qq", "<cmd>q!<cr>", silent("Quit All"))

return {
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		},
	},

	-- which-key
	{

		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n", "v" },
				["<leader>n"] = { name = "neovim" },
			},
		},

		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
}

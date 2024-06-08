return {
	-- colorscheme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function(_, _)
			require("rose-pine").setup({
				variant = "moon", -- main, moon, or dawn
				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},
			})

			vim.cmd("colorscheme rose-pine")
		end,
	},

	-- fuzzy-finder
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
				["<leader>n"] = { name = "Neovim" },
				["<leader>b"] = { name = "Buffers" },
			},
		},

		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
}

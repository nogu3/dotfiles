return {
	-- bufferline
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			-- FIXME Not Working
			-- { "<C-p>", "<cmd>bprev<cr>", desc = "Prev Buffer" },
			{ "<C-n>", "<cmd>bnext<cr>", desc = "Next Buffer" },
			{ "<leader>d", "<cmd>bd<cr>", desc = "Delete Buffer" },
			{ "<leader>D", "<cmd>bd!<cr>", desc = "Force Delete Buffer" },
			{ "<leader>ba", "<cmd>%bd<cr>", desc = "Delete All Buffers" },
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
		end,
	},

	--lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},
}

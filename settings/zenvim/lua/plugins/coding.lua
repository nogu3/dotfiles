return {
	{

		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = true,
		cmd = "ConformInfo",
		opts = {},
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = {
			{ "<leader>nm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		config = true,
	},
}

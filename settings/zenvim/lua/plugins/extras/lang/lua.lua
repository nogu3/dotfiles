return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			list_extend_with_nil(opts.ensure_installed, {
				"stylua",
			})
		end,
	},
}

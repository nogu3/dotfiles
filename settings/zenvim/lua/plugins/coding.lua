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
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = {},
		},
		-- https://github.com/LazyVim/LazyVim/blob/547dc76a12309d4dafc970ae08832140eae51cba/lua/lazyvim/plugins/lsp/init.lua#L218
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)

			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
}

return {
	-- noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
		keys = {
			{ "<leader>nn", "<cmd>Noice<cr>", desc = "Noice" },
		},
		config = function(_, opts)
			require("noice").setup(opts)
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			stages = "slide",
			timeout = 3000,
		},
	},

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
		-- FIXME Statusline format
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				disabled_filetypes = { statusline = { "dashboard" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"filetype",
						icon_only = true,
						separator = "",
						padding = {
							left = 1,
							right = 0,
						},
					},
					{
						"filename",
						path = 1,
						symbols = {
							-- Text to show when the file is modified.
							modified = "[+]",
							-- Text to show when the file is non-modifiable or readonly.
							readonly = "[-]",
							-- Text to show for unnamed buffers.
							unnamed = "[No Name]",
							-- Text to show for newly created file before first write
							newfile = "[New]",
						},
					},
				},
				lualine_x = { "encoding" },
				lualine_y = { "filetype" },
				-- FIXME Change Ln: n, Col: n
				lualine_z = { "location" },
			},
		},
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},

	-- dashboard
	{
		"nvimdev/dashboard-nvim",
		lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
		event = "VimEnter",
		opts = function()
			-- FIXME indent
			local logo = [[
███████╗███████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗
╚══███╔╝██╔════╝████╗  ██║██║   ██║██║████╗ ████║
  ███╔╝ █████╗  ██╔██╗ ██║██║   ██║██║██╔████╔██║
 ███╔╝  ██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
███████╗███████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"

			local opts = {
				theme = "doom",
				hide = {
					-- this is taken care of by lualine
					-- enabling this messes up the actual laststatus setting after loading a file
					statusline = false,
				},
				config = {
					header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",                           desc = " Find File",       icon = " ", key = "f" },
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                             desc = " Recent Files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                            desc = " Find Text",       icon = " ", key = "g" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
          },
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "DashboardLoaded",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			return opts
		end,
	},
}

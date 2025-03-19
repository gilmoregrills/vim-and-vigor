return {
	-- which-key (needs more work)
	{
		"folke/which-key.nvim",
		-- event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			preset = "classic",
			win = {
				border = "rounded",
				padding = { 0, 0 },
				title = false,
			},
			layout = {
				align = "center",
			},
			icons = {
				separator = "→",
				group = "+",
				ellipsis = "...",
				breadcrumb = "»",
				mappings = false,
				keys = {
					Tab = "<tab>",
					Space = "<space>",
					BS = "<backspace>",
					Left = "←",
					Right = "→",
					Up = "↑",
					Down = "↓",
					Esc = "<esc>",
					Leader = "<leader>",
				},
				-- show_help = false,
				-- show_keys = false,
				colors = false,
			},
		},
	},
	-- lualine, like the old airline but faster
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = auto,
			icons_enabled = false,
			extensions = {
				"trouble",
				"neo-tree",
				"lazy",
			},
		},
	},
	-- nui, extra ui components
	-- CAN I REMOVE?
	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},
	-- shows indentations with nice red line
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"terminal",
					"markdown",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	-- file fuzzy finder and stuff, like new vim-clap
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = {
				layout_config = {
					-- preview_width = 0.5,
				},
			},
			extensions = {
				file_browser = {
					-- theme = "dropdown",
					hidden = true,
					show_hidden = true,
					disable_devicons = true,
				},
			},
			pickers = {
				find_files = {
					-- theme = "dropdown",
				},
			},
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"folke/edgy.nvim",
		-- event = "VeryLazy",
		init = function()
			vim.opt.laststatus = 3
			vim.opt.splitkeep = "screen"
		end,
		opts = {
			animate = {
				enabled = false,
			},
			icons = {
				closed = "",
				open = "",
			},
			bottom = {
				"👷‍♀️ trouble",
				{ ft = "qf", title = "QuickFix" },
				{
					ft = "help",
					size = { height = 20 },
					-- only show help buffers
					filter = function(buf)
						return vim.bo[buf].buftype == "help"
					end,
				},
				{ ft = "spectre_panel", size = { height = 0.4 } },
			},
		},
	},
	{
		"echasnovski/mini.starter",
		version = "*",
		lazy = false,
		config = true,
		init = function()
			-- require("zen-mode").toggle({})
		end,
	},
	{
		"rktjmp/lush.nvim",
	},
	{
		"rktjmp/shipwright.nvim",
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
			float = {
				padding = 5,
				max_width = 0.7,
				max_height = 0.8,
			},
		},
		-- Optional dependencies
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	{
		"numToStr/FTerm.nvim",
		opts = {
			border = "rounded",
		},
	},
}

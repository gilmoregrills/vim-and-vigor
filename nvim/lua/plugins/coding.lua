return {
	"folke/neodev.nvim",
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	-- pairs of quotes and brackets and stuff
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup({})
		end,
	},
	-- commenter, use gcc to comment a line, or select and hit gc
	{
		"echasnovski/mini.comment",
		version = "*",
		config = function(_, opts)
			require("mini.comment").setup({})
		end,
	},
	-- surround
	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			local mappings = {
				{ opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete surrounding" },
				{ opts.mappings.find, desc = "Find right surrounding" },
				{ opts.mappings.find_left, desc = "Find left surrounding" },
				{ opts.mappings.highlight, desc = "Highlight surrounding" },
				{ opts.mappings.replace, desc = "Replace surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = "gza", -- Add surrounding in Normal and Visual modes
				delete = "gzd", -- Delete surrounding
				find = "gzf", -- Find surrounding (to the right)
				find_left = "gzF", -- Find surrounding (to the left)
				highlight = "gzh", -- Highlight surrounding
				replace = "gzr", -- Replace surrounding
				update_n_lines = "gzn", -- Update `n_lines`
			},
		},
	},
	-- treesitter-textobjects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		init = function()
			-- disable rtp plugin, as we only need its queries for mini.ai
			-- In case other textobject modules are enabled, we will load them
			-- once nvim-treesitter is loaded
			require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
			load_textobjects = true
		end,
	},
	-- treesitter core config
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true
				end,
			},
		},
		cmd = { "TSUpdateSync" },
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		---@type TSConfig
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"terraform",
				"hcl",
				"go",
				"gomod",
				"gowork",
				"gosum",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)

			if load_textobjects then
				-- PERF: no need to load the plugin, if we only need its queries for mini.ai
				if opts.textobjects then
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then
							local Loader = require("lazy.core.loader")
							Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
							local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
							require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
							break
						end
					end
				end
			end
		end,
	},
	-- language server plugin manager
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	-- 	config = function(_, opts)
	-- 		require("mason").setup({})
	-- 	end,
	-- },
	-- -- mason/lspconfig compatibility
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	config = function(_, opts)
	-- 		require("mason-lspconfig").setup({})
	-- 	end,
	-- 	dependencies = {
	-- 		"williamboman/mason.nvim",
	-- 	},
	-- },
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
		-- 		dependencies = {
		-- 			"williamboman/mason.nvim",
		-- 			"williamboman/mason-lspconfig.nvim",
		-- 		},
	},
	-- formatter, works with mason & treesitter(?)
	{
		"mhartington/formatter.nvim",
		config = function(_, opts)
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
						function()
							local util = require("formatter.util")
							if util.get_current_buffer_file_name() == "special.lua" then
								return nil
							end

							return {
								exe = "stylua",
								args = {
									"--search-parent-directories",
									"--stdin-filepath",
									util.escape_path(util.get_current_buffer_file_path()),
									"--",
									"-",
								},
								stdin = true,
							}
						end,
					},
					sh = {
						require("formatter.filetypes.sh").beautysh,
						function()
							return {
								exe = "beautysh",
								args = {
									"--indent-size=2",
								},
								stdin = true,
							}
						end,
					},
					terraform = {
						require("formatter.filetypes.terraform").terraformfmt,
						function()
							return {
								exe = "terraform",
								args = {
									"fmt",
									"-",
								},
								stdin = true,
							}
						end,
					},
					go = {
						require("formatter.filetypes.go").gofmt,
						require("formatter.filetypes.go").goimports,
					},
					python = {
						require("formatter.filetypes.python").black,
						require("formatter.filetypes.python").isort,
					},
					yaml = {
						require("formatter.filetypes.yaml").pyaml,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
	-- linting
	{
		"mfussenegger/nvim-lint",
	},
	-- shows diagnostics in a nice window instead of inline :)
	{
		"folke/trouble.nvim",
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			icons = false,
			auto_open = true,
			auto_close = true,
			fold_open = "v",
			fold_closed = ">",
			signs = {
				-- icons / text used for a diagnostic
				error = "error",
				warning = "warn",
				hint = "hint",
				information = "info",
			},
			use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
		},
	},
	-- {
	-- 	"huggingface/hfcc.nvim",
	-- 	opts = {
	-- 		model = "bigcode/starcoder",
	-- 		api_token = os.getenv("HUGGING_FACE_HUB_TOKEN"),
	-- 		accept_keymap = "<C-a>",
	-- 		dismiss_keymap = "<C-A>",
	-- 		fim = {
	-- 			enabled = true,
	-- 			prefix = "<fim_prefix>",
	-- 			middle = "<fim_middle>",
	-- 			suffix = "<fim_suffix>",
	-- 		},
	-- 	},
	-- },
	-- { "nvim-neotest/neotest-plenary" },
	-- { "nvim-neotest/neotest-go" },
	-- {
	-- 	"nvim-neotest/neotest",
	-- 	opts = {
	-- 		adapters = {
	-- 			"neotest-go",
	-- 		},
	-- 		status = { virtual_text = true },
	-- 		output = { open_on_run = false },
	-- 		output_panel = {
	-- 			enabled = true,
	-- 			open = "botright split | resize 15",
	-- 		},
	-- 		quickfix = {
	-- 			enabled = true,
	-- 			open = function()
	-- 				vim.cmd("Trouble quickfix")
	-- 			end,
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		local neotest_ns = vim.api.nvim_create_namespace("neotest")
	-- 		vim.diagnostic.config({
	-- 			virtual_text = {
	-- 				format = function(diagnostic)
	-- 					-- Replace newline and tab characters with space for more compact diagnostics
	-- 					local message =
	-- 						diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
	-- 					return message
	-- 				end,
	-- 			},
	-- 		}, neotest_ns)

	-- 		if opts.adapters then
	-- 			local adapters = {}
	-- 			for name, config in pairs(opts.adapters or {}) do
	-- 				if type(name) == "number" then
	-- 					if type(config) == "string" then
	-- 						config = require(config)
	-- 					end
	-- 					adapters[#adapters + 1] = config
	-- 				elseif config ~= false then
	-- 					local adapter = require(name)
	-- 					if type(config) == "table" and not vim.tbl_isempty(config) then
	-- 						local meta = getmetatable(adapter)
	-- 						if adapter.setup then
	-- 							adapter.setup(config)
	-- 						elseif meta and meta.__call then
	-- 							adapter(config)
	-- 						else
	-- 							error("Adapter " .. name .. " does not support setup")
	-- 						end
	-- 					end
	-- 					adapters[#adapters + 1] = adapter
	-- 				end
	-- 			end
	-- 			opts.adapters = adapters
	-- 		end

	-- 		require("neotest").setup(opts)
	-- 	end,
	-- 	-- stylua: ignore
	-- },
}

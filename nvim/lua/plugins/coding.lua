return {
	"folke/neodev.nvim",
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	-- pairs of quotes and brackets and stuff
	{
		"echasnovski/mini.pairs",
		-- event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup({})
		end,
	},
	-- commenter, use gcc to comment a line, or select and hit gc
	{
		"echasnovski/mini.comment",
		version = "*",
		config = function(_, opts)
			require("mini.comment").setup({
				mappings = {
					-- Toggle comment on current line
					comment_line = "<Leader>c",
					-- Toggle comment on visual selection
					comment_visual = "<Leader>c",
				},
			})
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
				add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
				delete = "<Leader>sd", -- Delete surrounding
				find = "<Leader>sf", -- Find surrounding (to the right)
				find_left = "<Leader>sF", -- Find surrounding (to the left)
				highlight = "<Leader>sh", -- Highlight surrounding
				replace = "<Leader>sr", -- Replace surrounding
				update_n_lines = "<Leader>sn", -- Update `n_lines`
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
	-- lspconfig
	{
		"neovim/nvim-lspconfig",
	},
	-- formatter, works with mason & treesitter(?)
	{
		"mhartington/formatter.nvim",
		config = function(_, opts)
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					javascript = {
						require("formatter.filetypes.javascript").prettier,
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").prettier,
					},
					typescript = {
						require("formatter.filetypes.typescript").prettier,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").prettier,
					},
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
						require("formatter.filetypes.yaml"),
						function()
							return {
								exe = "yq",
								args = {
									".",
									"--prettyPrint",
								},
								stdin = true,
							}
						end,
					},
					json = {
						require("formatter.filetypes.json"),
						function()
							return {
								exe = "jq",
								args = {
									".",
								},
								stdin = true,
							}
						end,
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
			modes = {
				diagnostics = {
					auto_open = false,
					auto_close = true,
					auto_preview = false,
					focus = false,
					follow = true,
					pinned = true,
				},
			},
			icons = {
				indent = {
					fold_open = "",
					fold_closed = "",
				},
				folder_closed = ">",
				folder_open = "v",
				kinds = {
					Array = "[]",
					Boolean = "bool",
					Class = "Class",
					Constant = "const",
					Constructor = "Const",
					Enum = "enum",
					EnumMember = "enumM",
					Event = "event",
					Field = "field",
					File = "file",
					Function = "func",
					Interface = "int",
					Key = "key",
					Method = "method",
					Module = "mod",
					Namespace = "ns",
					Null = "null",
					Number = "number",
					Object = "Obj",
					Operator = "op",
					Package = "pkg",
					Property = "prop",
					String = "str",
					Struct = "Str",
					TypeParameter = "param",
					Variable = "var",
				},
			},
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
	-- 	"hrsh7th/nvim-cmp",
	-- 	version = false, -- last release is way too old
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 		"saadparwaiz1/cmp_luasnip",
	-- 	},
	-- 	opts = function()
	-- 		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
	-- 		local cmp = require("cmp")
	-- 		local defaults = require("cmp.config.default")()
	-- 		return {
	-- 			completion = {
	-- 				completeopt = "menu,menuone,noinsert",
	-- 			},
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					require("luasnip").lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 				["<C-Space>"] = cmp.mapping.complete(),
	-- 				["<C-e>"] = cmp.mapping.abort(),
	-- 				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	-- 				["<S-CR>"] = cmp.mapping.confirm({
	-- 					behavior = cmp.ConfirmBehavior.Replace,
	-- 					select = true,
	-- 				}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	-- 			}),
	-- 			sources = cmp.config.sources({
	-- 				{ name = "nvim_lsp" },
	-- 				{ name = "luasnip" },
	-- 				{ name = "buffer" },
	-- 				{ name = "path" },
	-- 			}),
	-- 			experimental = {
	-- 				ghost_text = {
	-- 					hl_group = "CmpGhostText",
	-- 				},
	-- 			},
	-- 			sorting = defaults.sorting,
	-- 		}
	-- 	end,
	-- },
	{
		"github/copilot.vim",
	},
}

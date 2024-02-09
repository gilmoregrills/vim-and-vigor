return {
	-- which-key (needs more work)
	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		vim.o.timeout = true
	-- 		vim.o.timeoutlen = 300
	-- 	end,
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	},
	-- },
	-- lualine, like the old airline but faster
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "auto",
		},
	},
	-- nui, extra ui components
	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},
	-- tree file explorer on left
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
		opts = {
			close_if_last_window = false,
			use_popups_for_input = false,
			enable_git_status = true,
			enable_diagnostics = true,
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
			modified = {
				symbol = "[+]",
				highlight = "NeoTreeModified",
			},

			default_component_configs = {
				name = {
					use_git_status_colors = false,
					trailing_slash = true,
				},
				indent = {
					expander_collapsed = "+",
					expander_expanded = "-",
					with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
				},
				git_status = {
					symbols = {
						deleted = "-",
						renamed = "r",
						modified = "+",
						untracked = "?",
						ignored = "i",
						unstaged = "u",
						staged = "s",
						conflict = "!",
					},
				},
				container = {
					enable_character_fade = false,
					width = "70%",
				},
			},
			filesystem = {
				components = {
					icon = function(config, node, state)
						if node.type == "file" or node.type == "directory" then
							return {}
						end
						return require("neo-tree.sources.common.components").icon(config, node, state)
					end,
				},
				bind_to_cwd = false,
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		},
		init = function()
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
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
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
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
			left = {
				-- Neo-tree filesystem always takes half the screen height
				{
					title = "🌳 neotree",
					ft = "neo-tree",
					filter = function(buf)
						return vim.b[buf].neo_tree_source == "filesystem"
					end,
				},
			},
		},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "/Users/robinyonge/obsidian/personal/",
				},
			},
			daily_notes = {
				-- Optional, if you keep daily notes in a separate directory.
				folder = "daily",
				template = "daily.md",
				date_format = "%d-%m-%y",
			},
			templates = {
				subdir = "templates",
			},
		},
	},
	{
		"vimwiki/vimwiki",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		init = function()
			vim.cmd([[
        let wiki_1 = {}
        let wiki_1.path = '~/vimwiki/'
        let wiki_1.syntax = 'markdown'
        let wiki_1.ext = '.md'

        let g:vimwiki_list = [wiki_1]
        let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}

        let g:vimwiki_global_ext = 0
        let g:vimwiki_markdown_link_ext = 1
        let g:vimwiki_folding = 'expr'
        autocmd filetype markdown setlocal foldmethod=expr
        autocmd filetype markdown setlocal nofoldenable
        let g:markdown_folding = 1
        let g:markdown_fenced_languages = ['py=python', 'json', 'yml=yaml', 'bash=sh']
      ]])
		end,
	},
	{
		"masukomi/vim-markdown-folding",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		init = function()
			vim.cmd([[
        if has("autocmd")
          filetype plugin indent on
        endif
      ]])
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {

			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
}

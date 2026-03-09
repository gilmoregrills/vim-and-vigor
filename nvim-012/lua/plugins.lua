-- mini.comment
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.comment", version = "main" },
})

require("mini.comment").setup({
	mappings = {
		-- Toggle comment on current line
		comment_line = "<Leader>c",
		-- Toggle comment on visual selection
		comment_visual = "<Leader>c",
	},
})

-- mini.surround
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.surround", version = "main" },
})

require("mini.surround").setup({
	mappings = {
		add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
		delete = "<Leader>sd", -- Delete surrounding
		find = "<Leader>sf", -- Find surrounding (to the right)
		find_left = "<Leader>sF", -- Find surrounding (to the left)
		highlight = "<Leader>sh", -- Highlight surrounding
		replace = "<Leader>sr", -- Replace surrounding
		update_n_lines = "<Leader>sn", -- Update `n_lines`
	},
	custom_surroundings = {
		["("] = { output = { left = "(", right = ")" } },
		[")"] = { output = { left = "( ", right = " )" } },
	},
})

-- formatter.nvim
vim.pack.add({
	{ src = "https://github.com/mhartington/formatter.nvim", version = "master" },
})

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
			require("formatter.filetypes.sh").shfmt,
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
		tf = {
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
		hcl = {
			require("formatter.filetypes.terraform").terraformfmt,
			function()
				return {
					exe = "terraform",
					args = {
						"fmt",
						"-no-color",
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
			require("formatter.filetypes.yaml").prettier,
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
		rego = {
			function()
				return {
					exe = "opa",
					args = {
						"fmt",
					},
					stdin = true,
				}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
	},
})

-- nvim-lint
vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-lint", version = "master" },
})

-- require("lint").setup({})

require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	-- terraform = { "tflint" },
	-- hcl = { "tflint" },
	python = { "pylint" },
	go = { "golangcilint" },
	yaml = { "yamllint" },
	json = { "eslint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascript = { "eslint" },
	javascriptreact = { "eslint" },
	rego = { "regal" },
}

-- trouble
vim.pack.add({
	{ src = "https://github.com/folke/trouble.nvim", version = "main" },
})

require("trouble").setup({
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
})

-- copilot
vim.pack.add({
	{ src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
})

require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		hide_during_completion = true,
		keymap = {
			accept_word = "<C-l>",
			next = "<C-k>",
			prev = "<C-j>",
		},
	},
	filetypes = {
		gitcommit = true,
		gitrebase = true,
		python = true,
		tf = true,
		terraform = true,
	},
})

-- copilot-lualine
vim.pack.add({
	{ src = "https://github.com/AndreM222/copilot-lualine", version = "main" },
})

-- require("copilot-lualine").setup({})

-- lualine
vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },
})

require("lualine").setup({
	options = {
		extensions = {
			"trouble",
			"neo-tree",
			"lazy",
		},
		section_separators = { left = "", right = "" },
		component_separators = "",
		always_divide_middle = false,
	},
	theme = auto,
	-- icons_enabled = false,
	-- component_separators = { left = "", right = "" },
	-- section_separators = { left = "", right = "" },
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "", right = "" }, right_padding = 2 },
		},
		lualine_b = {
			{
				"branch",
				left_padding = 2,
				-- color = { bg = "#eceafa", fg = "#a29acb" },
				separator = { right = "" },
			},
			{
				"diff",
				-- color = { bg = "#eceafa", fg = "#a29acb" },
				separator = { right = "" },
			},
			{
				"diagnostics",
				icons_enabled = false,
				-- color = { bg = "#eceafa", fg = "#a29acb" },
				separator = { right = "" },
				right_padding = 2,
			},
		},
		lualine_c = {
			{ "filename", path = 3, left_padding = 3 },
		},
		lualine_x = {
			{},
		},
		lualine_y = {
			{
				"copilot",

				symbols = {
					-- spinners = {
					-- 	"😿",
					-- 	"😹",
					-- },
					spinners = "dots",
					status = {
						icons = {
							enabled = "✓",
							sleep = "⏾",
							disabled = "⨯",
							warning = "⚠",
							unknown = "﹖",
						},
					},
					-- status = {
					-- 	icons = {
					-- 		enabled = "😸",
					-- 		sleep = "😺",
					-- 		disabled = "😾",
					-- 		warning = "🙀",
					-- 		unknown = "😿",
					-- 	},
					-- },
				},
				-- color = { bg = "#eceafa", fg = "#a29acb" },
			},
			-- {
			-- 	"lsp_status",
			-- 	symbols = {
			-- 		-- Standard unicode symbols to cycle through for LSP progress:
			-- 		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
			-- 		-- Standard unicode symbol for when LSP is done:
			-- 		done = "✓",
			-- 		-- Delimiter inserted between LSP names:
			-- 		separator = "|",
			-- 	},
			-- 	icon = "",
			-- 	color = { bg = "#eceafa", fg = "#a29acb" },
			-- },
			-- { "filetype", color = { bg = "#eceafa", fg = "#a29acb" } },
			{ "filetype" },
		},
		lualine_z = {
			{ "location" },
			{
				"progress",
				right_padding = 2,
				separator = { right = "" },
			},
		},
	},
	inactive_sections = {
		-- lualine_a = {},
		-- 	lualine_b = { branch, diff, diagnostics },
		-- 	lualine_c = {},
		-- 	lualine_x = {},
		-- 	lualine_y = {},
		-- lualine_z = {},
	},
})

-- nui
-- CAN I REMOVE?
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim", version = "main" },
})

-- require("nui").setup({})

-- mini.indentscope
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.indentscope", version = "main" },
})

require("mini.indentscope").setup({})

-- plenary
-- required by telescope
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
})

-- require("plenary").setup({})

-- telescope
vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "v0.2.1" },
})

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add
-- Opens list of results in trouble under "Telescope" heading
local open_with_trouble = require("trouble.sources.telescope").open

-- require("telescope").load_extension("file_browser")
require("telescope").setup({
	defaults = {
		layout_config = {
			-- preview_width = 0.5,
		},
		mappings = {
			i = { ["<c-t>"] = open_with_trouble },
			n = { ["<c-t>"] = open_with_trouble },
		},
	},
	extensions = {
		-- file_browser = {
		-- 	-- theme = "dropdown",
		-- 	hidden = true,
		-- 	show_hidden = true,
		-- 	disable_devicons = true,
		-- },
	},
	pickers = {
		find_files = {
			-- theme = "dropdown",
		},
	},
})

-- which-key
vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim", version = "stable" },
})

require("which-key").setup({
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
})

-- edgy
vim.pack.add({
	{ src = "https://github.com/folke/edgy.nvim", version = "main" },
})

require("edgy").setup({
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
})

-- mini.starter
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.starter", version = "main" },
})

require("mini.starter").setup({
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 5,
		max_width = 0.7,
		max_height = 0.8,
		border = "rounded",
	},
	columns = {},
})

-- oil.nvim
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim", version = "stable" },
})

require("oil").setup({})

-- fterm
vim.pack.add({
	{ src = "https://github.com/numToStr/FTerm.nvim", version = "master" },
})

require("FTerm").setup({
	border = "rounded",
})

-- luatab
vim.pack.add({
	{ src = "https://github.com/alvarosevilla95/luatab.nvim", version = "master" },
})

require("luatab").setup({
	devicon = function()
		return ""
	end,
})

-- tiny-inline-diagnostic
vim.pack.add({
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim", version = "main" },
})

require("tiny-inline-diagnostic").setup({
	signs = {
		left = "",
		right = "",
		diag = "●",
		arrow = "← ",
		up_arrow = "↑ ",
		vertical = " │",
		vertical_end = " └",
	},
})

-- colorschemes
-- soft-era-nvim
vim.pack.add({
	{ src = "https://github.com/gilmoregrills/soft-era-nvim", version = "main" },
})

-- require("soft-era-nvim").setup({})

-- soft.nvim
vim.pack.add({
	{ src = "https://github.com/gilmoregrills/soft-era-nvim", version = "remove-lush" },
})

-- require("soft-era-nvim").setup({})

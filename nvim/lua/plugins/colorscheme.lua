return {
	{
		url = "git@github.com:tssm/fairyfloss.vim.git",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme fairyfloss]])
			vim.cmd([[set termguicolors]])
			vim.cmd([[highlight Comment cterm=italic gui=italic]])
			vim.cmd([[highlight Function cterm=italic gui=italic]])
			vim.cmd([[highlight Keyword cterm=italic gui=italic]])
			vim.cmd([[highlight Type cterm=italic gui=italic]])
			vim.cmd([[highlight Class cterm=italic gui=italic]])
		end,
	},
}

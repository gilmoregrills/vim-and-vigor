return {
	{
		"gilmoregrills/soft-era-nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd([[colorscheme soft-era]])
		end,
	},
	{
		"soft.nvim",
		url = "https://github.com/gilmoregrills/soft-era-nvim",
		branch = "remove-lush",
		-- dir = "~/git/gilmoregrills/soft-era-nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		dev = false,
		-- config = function()
		-- 	vim.cmd([[colorscheme soft-era]])
		-- end,
	},
}

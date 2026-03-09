local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TabNewEntered", {
	callback = function()
		MiniStarter.open()
	end,
})

autocmd({ "BufReadPre" }, {
	callback = function() end,
})

augroup("__formatter__", { clear = true })

autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

autocmd({ "BufWritePost" }, {
	callback = function()
		-- vim.lsp.buf.format()
		require("lint").try_lint()
	end,
})

autocmd({ "BufEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

autocmd({ "TermOpen" }, {
	callback = function()
		vim.cmd("setlocal nonumber norelativenumber")
		vim.cmd("nnoremap <buffer> <C-c> i<C-c>")
		vim.cmd("startinsert")
	end,
})

autocmd("TermOpen", {
	desc = "Disable 'mini.indentscope' in terminal buffer",
	callback = function()
		vim.b[data.buf].miniindentscope_disable = true
	end,
})

autocmd("FileType", {
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

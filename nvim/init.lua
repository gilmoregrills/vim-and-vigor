vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	ui = {
		border = "shadow",
	},
})

require("keymap")

vim.api.nvim_create_autocmd("TabNewEntered", {
	callback = function()
		MiniStarter.open()
	end,
})

-- ugly ported vimscript stuff
vim.cmd([[
filetype plugin on
syntax on

set tabstop=2 shiftwidth=2 expandtab softtabstop=2

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END


set number
]])

require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	terraform = { "tflint" },
	hcl = { "tflint" },
	python = { "pylint" },
	go = { "golangcilint" },
	yaml = { "yamllint" },
	json = { "jsonlint" },
	typescript = { "eslint" },
	typescriptreact = { "eslint" },
	javascript = { "eslint" },
	javascriptreact = { "eslint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.diagnostic.config({
	virtual_text = false, -- Turn off inline diagnostics
})

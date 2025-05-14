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

require("lazy").setup("plugins", {})

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
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead *.md set nonumber

set tabstop=2 shiftwidth=2 expandtab softtabstop=2
set guifont=Dank\ Mono:h16

augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END

set number

autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
autocmd TermOpen * startinsert
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

require("telescope").load_extension("file_browser")

local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = { ["<c-t>"] = open_with_trouble },
			n = { ["<c-t>"] = open_with_trouble },
		},
	},
})

local disable_indentscope = function(data)
	vim.b[data.buf].miniindentscope_disable = true
end
vim.api.nvim_create_autocmd(
	"TermOpen",
	{ desc = "Disable 'mini.indentscope' in terminal buffer", callback = disable_indentscope }
)

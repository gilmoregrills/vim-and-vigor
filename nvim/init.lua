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

vim.api.nvim_set_option("number", true)
vim.api.nvim_set_option("tabstop", 2)
vim.api.nvim_set_option("shiftwidth", 2)
vim.api.nvim_set_option("expandtab", true)
vim.api.nvim_set_option("softtabstop", 2)

vim.api.nvim_create_autocmd("TabNewEntered", {
	callback = function()
		MiniStarter.open()
	end,
})

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

vim.lsp.enable("marksman")

vim.diagnostic.config({
	virtual_text = false, -- Turn off inline diagnostics
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
	callback = function() end,
})

vim.api.nvim_create_augroup("__formatter__", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- vim.lsp.buf.format()
		require("lint").try_lint()
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.cmd("setlocal nonumber norelativenumber")
		vim.cmd("nnoremap <buffer> <C-c> i<C-c>")
		vim.cmd("startinsert")
	end,
})

-- ugly ported vimscript stuff
-- vim.cmd([[
-- autocmd TermOpen * setlocal nonumber norelativenumber
-- autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
-- autocmd TermOpen * startinsert
-- ]])

if vim.g.neovide then
	-- Put anything you want to happen only in Neovide here
	vim.g.neovide_text_gamma = 0.8
	vim.g.neovide_text_contrast = 0.2
	vim.g.neovide_floating_shadow = false
	vim.g.neovide_macos_simple_fullscreen = true
end

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

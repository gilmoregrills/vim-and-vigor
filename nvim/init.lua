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

-- ugly ported vimscript stuff
vim.cmd([[
" filetype plugin on

map <C-n> :Neotree toggle<CR>
nmap <F1> :Telescope<CR>
nmap <F2> :Telescope find_files<CR>
nmap <F3> :Telescope live_grep<CR>
nmap <F4> :TroubleToggle document_diagnostics<CR>
nmap <F5> :Neotree float git_status<CR>

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

local group = vim.api.nvim_create_augroup("gotest", { clear = true })
local ns = vim.api.nvim_create_namespace("gotest")
local attach_go_test = function(bufnr, output_bufnr, command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*.go",
		callback = function()
			vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

			state = {
				bufnr = bufnr,
				tests = {},
			}

			vim.fn.jobstart(command, {
				stdout_buffered = true,

				on_stdout = function(_, data)
					if not data then
						return
					end

					for _, line in ipairs(data) do
						local decoded = vim.json.decode(line)
						-- if successful then
						-- 	print(line)
						-- 	print(type(line))
						-- 	print(response.Action)
						-- else
						-- 	print(response.code)
						-- end
					end
				end,

				on_exit = function()
					local failed = {}
					for _, test in pairs(state.tests) do
						if test.line then
							if not test.success then
								print("not test success")
								table.insert(failed, {
									bufnr = bufnr,
									lnum = test.line,
									col = 0,
									severity = vim.diagnostic.severity.ERROR,
									source = "go-test",
									message = "Test Failed",
									user_data = {},
								})
							end
						end
					end
					vim.diagnostic.set(ns, bufnr, failed, {})
				end,
			})
		end,
	})
end

vim.api.nvim_create_user_command("GoTestOnSave", function()
	local bufnr = vim.fn.input("output_buffer: ")
	attach_go_test(tonumber(vim.api.nvim_get_current_buf()), tonumber(bufnr), { "go", "test", "./...", "-v", "-json" })
end, {})

local attach_to_buffer = function(output_bufnr, pattern, command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("robin-automagic", { clear = true }),
		pattern = pattern,
		callback = function()
			local append_data = function(_, data)
				if data then
					vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
				end
			end
			vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "go test output:" })
			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = append_data,
				on_stderr = append_data,
			})
		end,
	})
end

-- get :buffers and then create an autocmd to run on save, outputting to that buffer
vim.api.nvim_create_user_command("AutoRun", function()
	print("testing...")
	local bufnr = vim.fn.input("buffer number: ")
	local pattern = vim.fn.input("pattern: ")
	local command = vim.split(vim.fn.input("command: "), " ")
	attach_to_buffer(tonumber(bufnr), pattern, command)
end, {})

vim.diagnostic.config({
	virtual_text = false, -- Turn off inline diagnostics
})

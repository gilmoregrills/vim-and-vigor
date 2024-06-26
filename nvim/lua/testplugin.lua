local group = vim.api.nvim_create_augroup("gotest", { clear = true })
local ns = vim.api.nvim_create_namespace("gotest")

local attach_go_test = function(bufnr, output_bufnr, command)
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*.go",
		callback = function()
			vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

			state = {
				bufnr = bufnr,
				output = {},
				tests = {},
			}

			vim.fn.jobstart(command, {
				stdout_buffered = true,

				on_stdout = function(_, data)
					if not data then
						return
					end

					for i, line in ipairs(data) do
						local decoded = vim.json.decode(line)
						table.insert(state.output, decoded)
						print(type(decoded))
						print(decoded.Action)
						if decoded.Action == "pass" or decoded.Action == "fail" then
							-- try and piece together a useful test output object with everything in it
							local test_data = {}
							test_data.status = decoded.Action
							test_data.package = decoded.Package
							test_data.name = decoded.Test
							local useful_output = state.output[i - 2].Output -- split this on ":" to get filename, line number, and message
							test_data.message = "blah"
							test_data.line = 2
							test_data.file = "deck_test.go"
							print("capturing test output")
							table.insert(state.tests, test_data)
						end
					end
				end,

				on_exit = function()
					local failed = {}
					for _, test in pairs(state.tests) do
						-- if test.line then
						if test.status == "fail" then
							print("logging failed test")
							table.insert(failed, {
								bufnr = bufnr,
								lnum = test.line,
								col = 0,
								severity = vim.diagnostic.severity.ERROR,
								source = "go-test",
								message = test.name .. ":" .. test.message,
								user_data = {},
							})
						end
						-- end
					end
					vim.diagnostic.set(ns, bufnr, failed, {})
				end,
			})
		end,
	})
end

vim.api.nvim_create_user_command("GoTestOnSave", function()
	-- local bufnr = vim.fn.input("output_buffer: ")
	attach_go_test(tonumber(vim.api.nvim_get_current_buf()), tonumber(2), { "go", "test", "./...", "-v", "-json" }) -- hardcoded to buffer 2 for now since it dont matter
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

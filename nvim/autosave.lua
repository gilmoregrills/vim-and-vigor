local bufnr = 12

vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "hello" })

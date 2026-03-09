-- Set default root markers for all clients
vim.lsp.config("*", {
	root_markers = { ".git" },
})

vim.lsp.enable({
	-- "bashls",
	-- "gopls",
	"lua_ls",
	-- "ts_ls",
	-- "marksman",
})
vim.diagnostic.config({ virtual_text = true })

local function setup_lsp_diags()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		signs = true,
		update_in_insert = false,
		underline = true,
	})
end

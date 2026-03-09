local map = vim.keymap.set
local set = vim.opt
local defaults = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

-- registering descriptions/flavour for which-key
local wk = require("which-key")
wk.add({
	{ "<leader>gc", group = "copilot" },
	{ "<leader>g", group = "git(hub)" },
	{ "<leader>f", group = "find/file" },
	{ "<leader>s", group = "surround" },
	{ "<leader>w", group = "windows" },
	{ "<leader>t", group = "(floating) terminal(s)" },
	{ "<leader>tf", group = "terraform" },
	{ "<leader>tk", group = "k8s" },
	{ "<leader>tb", group = "bottom" },
	{ "<leader>w<leader>", group = "diary" },
	{ "<leader>d", group = "diagnostics" },
	{ "<leader><tab>9", desc = "<leader><tab>9", hidden = true },
	{ "<leader><tab>4", desc = "<leader><tab>4", hidden = true },
	{ "<leader><tab>3", desc = "<leader><tab>3", hidden = true },
	{ "<leader><tab>5", desc = "<leader><tab>5", hidden = true },
	{ "<leader><tab>7", desc = "<leader><tab>7", hidden = true },
	{ "<leader><tab>6", desc = "<leader><tab>6", hidden = true },
	{ "<leader><tab>8", desc = "<leader><tab>8", hidden = true },
	{ "<leader><tab>2", desc = "<leader><tab>2", hidden = true },
	{ "<leader><tab>1", desc = "<leader><tab>1", hidden = true },
	{ "<leader><tab>", group = "tabs" },
	{ "<leader>c", desc = "comment", mode = { "n", "n" } },
	{ "<leader>l", group = "lists" },
	{ "<leader>h", group = "helpers" },
	{ "<leader>hd", group = "insert dates" },
	{ "<leader>a", group = "avante" },
})

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Using <leader> + <tab> + number (1, 2, ... 9) to switch tab
for i = 1, 9, 1 do
	map("n", "<leader><tab>" .. i, i .. "gt", { desc = "select tab 1(-9 etc)" })
end

-- window splits
map("n", "<leader>wh", "<C-w>h", { desc = "go to left window", remap = true })
map("n", "<leader>wH", "<C-w>H", { desc = "move window left", remap = true })
map("n", "<leader>wj", "<C-w>j", { desc = "go to lower window", remap = true })
map("n", "<leader>wJ", "<C-w>J", { desc = "move window down", remap = true })
map("n", "<leader>wk", "<C-w>k", { desc = "go to upper window", remap = true })
map("n", "<leader>wK", "<C-w>K", { desc = "move window up", remap = true })
map("n", "<leader>wl", "<C-w>l", { desc = "go to right window", remap = true })
map("n", "<leader>wL", "<C-w>L", { desc = "move window right", remap = true })
map("n", "<leader>wq", "<C-w>q", { desc = "quit window", remap = true })
map("n", "<leader>wo", "<C-w>o", { desc = "close all other windows", remap = true })
map("n", "<leader>w+", "<C-w>+", { desc = "increase height", remap = true })
map("n", "<leader>w-", "<C-w>-", { desc = "decrease height", remap = true })
map("n", "<leader>w<", "<C-w><", { desc = "decrease width", remap = true })
map("n", "<leader>w>", "<C-w>>", { desc = "increase width", remap = true })
map("n", "<leader>w=", "<C-w>=", { desc = "equalize splits", remap = true })
map("n", "<leader>wT", "<C-w>T", { desc = "break out into a new tab", remap = true })
map("n", "<leader>ws", "<C-w>s", { desc = "hsplit window", remap = true })
map("n", "<leader>wv", "<C-w>v", { desc = "vsplit window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "new tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<PageUp>", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>x", "<cmd>tabclose<cr>", { desc = "close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "previous tab" })
map("n", "<PageDown>", "<cmd>tabprevious<cr>", { desc = "previous tab" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "increase window width" })

-- Telescope
map("n", "<leader>ff", builtin.find_files, { desc = "telescope find_files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "telescope live_grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "telescope help_tags" })
map("n", "<leader>ft", builtin.filetypes, { desc = "telescope filetypes" })

-- map for quick quit, save files using leader key
---- Normal mode
-- map("n", "<Leader>s", ":write<CR>", { desc = "write" })
map("n", "<Leader>x", ":wq<CR>", { desc = "wq" })

-- Oil
map("n", "<leader>fn", ":Oil --float .<CR>", { desc = "oil toggle" })

-- Terminal
map("n", "<leader>tt", require("FTerm").toggle, { desc = "toggle" })
map("n", "<F3>", require("FTerm").toggle, { desc = "toggle" })
map("t", "<F3>", require("FTerm").toggle, { desc = "toggle" })
map("n", "<C-F3>", require("FTerm").exit, { desc = "toggle" })
map("t", "<C-F3>", require("FTerm").exit, { desc = "toggle" })
map("n", "<leader>tx", require("FTerm").exit, { desc = "exit" })
map("n", "<leader>to", require("FTerm").open, { desc = "open" })
map("n", "<leader>tc", require("FTerm").close, { desc = "close" })
map("n", "<leader>tv", ":vertical terminal<CR>", { desc = "vert" })
map("n", "<leader>tbr", ":botright terminal<CR>", { desc = "botright" })
map("n", "<leader>tbl", ":botleft terminal<CR>", { desc = "botleft" })
map("n", "<leader>tbb", ":bot terminal<CR>", { desc = "bottom" })

local fterm = require("FTerm")

-- Use this to toggle claude in a floating terminal
local claudeterm = fterm:new({
	ft = "fterm_gitui", -- You can also override the default filetype, if you want
	cmd = "claude",
	border = "rounded",
})
map("n", "<leader>tc", function()
	claudeterm:toggle()
end, { desc = "claude ✨" })

map("n", "<leader>tfi", function()
	fterm.scratch({
		cmd = { "terraform", "init" },
		border = "rounded",
	})
end, { desc = "init" })

map("n", "<leader>tft", function()
	fterm.scratch({
		cmd = { "terraform", "test" },
		border = "rounded",
	})
end, { desc = "test" })

map("n", "<leader>tfp", function()
	fterm.scratch({
		cmd = { "terraform", "plan" },
		border = "rounded",
	})
end, { desc = "plan" })

map("n", "<leader>ti", function()
	vim.ui.input({ prompt = "Enter command: " }, function(input)
		if input then
			fterm.scratch({
				cmd = vim.split(input, "%s+"),
				border = "rounded",
				auto_close = true,
			})
		end
	end)
end, { desc = "run cmd" })

map("n", "<leader>tk9", function()
	vim.ui.input({ prompt = "Enter cluster name: " }, function(input)
		if input then
			fterm.scratch({
				cmd = vim.split(string.format("kube_cloudflare.sh -i %s k9s", input), "%s+"),
				border = "rounded",
				auto_close = true,
			})
		end
	end)
end, { desc = "start k9s 🐶" })

-- Trouble
map("n", "<leader>dt", ":Trouble diagnostics toggle<CR>", { desc = "diagnostics toggle" })
map("n", "<leader>do", ":Trouble diagnostics open<CR>", { desc = "diagnostics open" })
map("n", "<leader>dc", ":Trouble diagnostics close<CR>", { desc = "diagnostics close" })
map("n", "<leader>dr", ":Trouble diagnostics refresh<CR>", { desc = "diagnostics refresh" })

-- copilot
map("n", "<leader>gcp", ":Copilot panel<CR>", { desc = "panel" })
map("n", "<leader>gcs", ":Copilot status<CR>", { desc = "status" })
map("n", "<leader>gce", ":Copilot enable<CR>", { desc = "enable" })
map("n", "<leader>gcd", ":Copilot disable<CR>", { desc = "disable" })
map("n", "<leader>gca", ":Copilot auth<CR>", { desc = "auth" })
map("n", "<leader>gcs", ":Copilot status<CR>", { desc = "status" })
map("n", "<leader>gcv", ":Copilot version<CR>", { desc = "version" })
map("n", "<leader>gcl", ":Copilot logs<CR>", { desc = "logs" })
map("i", "<c-tab>", "<Plug>(copilot-accept-word)", { desc = "accept word" })
map("i", "<c-s-tab>", "<Plug>(copilot-accept-line)", { desc = "accept line" })

-- terminal binds
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal" })

-- date helpers
map("n", "<leader>hdd", ":pu=strftime('%Y-%m-%d')<CR>", { desc = "YYYY-MM-DD" })
map("n", "<leader>hdh", ":pu=strftime('%a %d %b')<CR>", { desc = "Day DD Month" })
map("n", "<leader>hdf", ":pu=strftime('%a %d %b %Y')<CR>", { desc = "Day DD Month YYYY" })
map("n", "<leader>hdg", ":pu=strftime('%d %b %y')<CR>", { desc = "DD Month YY" })
map("n", "<leader>hds", ":pu=strftime('%d/%m')<CR>", { desc = "DD Month YY" })

local map = vim.keymap.set
local set = vim.opt
local defaults = { noremap = true, silent = true }
local builtin = require("telescope.builtin")

-- registering descriptions/flavour for which-key
local wk = require("which-key")
wk.register({
	["<tab>"] = {
		name = "tabs",
		["2"] = "which_key_ignore",
		["3"] = "which_key_ignore",
		["4"] = "which_key_ignore",
		["5"] = "which_key_ignore",
		["6"] = "which_key_ignore",
		["7"] = "which_key_ignore",
		["8"] = "which_key_ignore",
		["9"] = "which_key_ignore",
	},
	f = {
		name = "file/find",
	},
	w = {
		name = "wiki",
		g = {
			name = "git",
		},
		["<space>"] = {
			name = "diary",
		},
	},
	t = {
		name = "todo.txt",
	},
	g = {
		name = "git(hub)",
		c = {
			name = "copilot",
		},
	},
	d = {
		name = "diagnostics",
	},
	s = {
		name = "surround",
	},
	c = {
		name = "comment",
		c = {
			name = "comment",
		},
	},
}, { prefix = "<leader>" })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Using <leader> + <tab> + number (1, 2, ... 9) to switch tab
for i = 1, 9, 1 do
	map("n", "<leader><tab>" .. i, i .. "gt", { desc = "select tab 1(-9 etc)" })
end

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "first tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "new tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "next tab" })
map("n", "<leader><tab>x", "<cmd>tabclose<cr>", { desc = "close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "previous tab" })

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

-- map for quick quit, save files using leader key
---- Normal mode
-- map("n", "<Leader>s", ":write<CR>", { desc = "write" })
map("n", "<Leader>a", ":wqa<CR>", { desc = "wqa" })
map("n", "<Leader>x", ":wq<CR>", { desc = "wq" })

-- Neotree
-- map("n", "<leader>fn", ":Neotree toggle<CR>", { desc = "neotree toggle" })
map("n", "<leader>fn", ":Neotree float filesystem<CR>", { desc = "neotree toggle" })
map("n", "<leader>gg", ":Neotree float git_status<CR>", { desc = "neotree git_status" })

-- Todos
map("n", "<leader>tt", ":17sp /Users/robinyonge/todo/todo.txt<CR>", { desc = "open horizontal" })
map("n", "<leader>tv", ":50vs /Users/robinyonge/todo/todo.txt<CR>", { desc = "open vertical" })

-- Trouble
map("n", "<leader>dt", ":TroubleToggle document_diagnostics<CR>", { desc = "toggle for document" })
map("n", "<leader>dw", ":TroubleToggle workspace_diagnostics<CR>", { desc = "toggle for workspace" })
map("n", "<leader>dw", ":TroubleToggle quickfix<CR>", { desc = "toggle quickfix" })
map("n", "<leader>dx", ":TroubleClose<CR>", { desc = "close" })
map("n", "<leader>dr", ":TroubleRefresh<CR>", { desc = "refresh" })

-- vimwiki git sync
map(
	"n",
	"<leader>wgs",
	":!(cd /Users/robinyonge/vimwiki; /usr/bin/git add -A; /usr/bin/git commit -m 'update'; /usr/bin/git pull; /usr/bin/git push)<CR>",
	{ desc = "git sync" }
)
map(
	"n",
	"<leader>wgc",
	":!(cd /Users/robinyonge/vimwiki; /usr/bin/git add -A; /usr/bin/git commit -m 'update')<CR>",
	{ desc = "git commit" }
)
map("n", "<leader>wgd", ":!(cd /Users/robinyonge/vimwiki; /usr/bin/git pull)<CR>", { desc = "git download" })
map("n", "<leader>wgu", ":!(cd /Users/robinyonge/vimwiki; /usr/bin/git push)<CR>", { desc = "git upload" })

-- switch to journal filetype and back to wiki
map("n", "<leader>fj", ":set filetype=journal<CR>", { desc = "filetype=journal" })
map("n", "<leader>fw", ":set filetype=vimwiki<CR>", { desc = "filetype=wiki" })

map("n", "<leader>gcp", ":Copilot panel<CR>", { desc = "panel" })
map("n", "<leader>gcs", ":Copilot status<CR>", { desc = "status" })
map("n", "<leader>gce", ":Copilot enable<CR>", { desc = "enable" })
map("n", "<leader>gcd", ":Copilot disable<CR>", { desc = "disable" })
map("n", "<leader>gcs", ":Copilot auth<CR>", { desc = "auth" })
map("n", "<leader>gcv", ":Copilot version<CR>", { desc = "version" })
map("n", "<leader>gcl", ":Copilot logs<CR>", { desc = "logs" })
map("i", "<tab>", "<Plug>(copilot-accept-word)")
map("i", "<C-Tab>", "<Plug>(copilot-accept-line)", { desc = "accept line" })

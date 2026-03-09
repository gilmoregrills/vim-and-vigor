local o = vim.o

vim.cmd.colorscheme("soft-era")

o.swapfile = false -- Disable swap files
o.autoindent = true -- Enable auto indentation
o.expandtab = true -- Use spaces instead of tabs
o.tabstop = 2 -- Number of spaces for a tab
o.softtabstop = 2 -- Number of spaces for a tab when editing
o.shiftwidth = 2 -- Number of spaces for autoindent
o.shiftround = true -- Round indent to multiple of shiftwidth
-- o.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Characters to show for tabs, spaces, and end of line
-- o.list = true -- Show whitespace characters
o.number = true -- Show line numbers
o.relativenumber = false -- Show relative line numbers
o.numberwidth = 2 -- Width of the line number column
o.wrap = false -- Disable line wrapping
o.cursorline = false -- Highlight the current line
-- o.scrolloff = 8 -- Keep 8 lines above and below the cursor
o.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
o.winborder = "rounded" -- Use rounded borders for windows
o.timeout = true
o.timeoutlen = 300
o.laststatus = 3
o.splitkeep = "screen"

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

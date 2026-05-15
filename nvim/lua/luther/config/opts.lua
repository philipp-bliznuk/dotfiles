local opt = vim.opt

-- Enable bytecode cache
vim.loader.enable()

-- Line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- Tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 0 -- use tabstop value
opt.expandtab = true -- expand tab to spaces

-- Split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Disable line wrapping
opt.wrap = false

-- Undo persistence
vim.opt.undofile = true

-- Decrease update time
opt.updatetime = 250

-- Enable local configuration
vim.opt.exrc = true

-- Search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Cursor line
opt.cursorline = true -- highlight the current cursor line

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- Turn off swapfile
opt.swapfile = false

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear search highlights
map("n", "<esc>", "<esc><cmd>nohlsearch<cr>")

-- Delete single character w/out copying it into register
map("n", "x", '"_x')

-- Move selected lines w/ indentation
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Page up/down and center
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Next/prev search result and center
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Join line below and keep cursor in place
map("n", "J", "mzJ`z")

-- Delete into void register
map({ "n", "v" }, "<leader>d", '"_d')

-- Paste w/out loosing what's in the register
map("x", "<leader>p", '"_dP')

-- Paste from system clipboard
map({ "n", "v" }, "<leader>P", '"+P')

-- Yank into system clipboard
map({ "n", "v" }, "<leader>Y", '"+y')

-- Disable Ex mode
map("n", "Q", "<nop>")

-- Replace a word under cursor
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Replace selected text
map("x", "<leader>s", [["zy<Esc>:%s/<C-R>z//g<Left><Left>]])

-- Navigate between windows
map("n", "<C-k>", ":wincmd k<CR>")
map("n", "<C-j>", ":wincmd j<CR>")
map("n", "<C-h>", ":wincmd h<CR>")
map("n", "<C-l>", ":wincmd l<CR>")

local map = require("util").map

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Delete single char without yanking
map("n", "x", '"_x', { desc = "Delete char (no yank)" })

-- Move lines (visual mode)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Move lines (normal mode)
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })

-- Join line keeping cursor position
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Centered search navigation
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Void register operations
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void register" })
map("x", "<leader>p", '"_dP', { desc = "Paste without losing register" })

-- System clipboard (explicit)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>P", '"+p', { desc = "Paste from system clipboard" })

-- Disable Ex mode
map("n", "Q", "<nop>", { desc = "Disabled" })

-- Search and replace word under cursor
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("x", "<leader>sr", [["zy:%s/<C-r>z/<C-r>z/gI<Left><Left><Left>]], { desc = "Replace selection" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- Split creation
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertical" })

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      pcall(vim.api.nvim_buf_delete, buf, {})
    end
  end
end, { desc = "Close other buffers" })
map("n", "<leader>bl", "<cmd>buffer #<CR>", { desc = "Last buffer" })

-- Quickfix navigation
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[Q", "<cmd>cfirst<CR>zz", { desc = "First quickfix" })
map("n", "]Q", "<cmd>clast<CR>zz", { desc = "Last quickfix" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Diagnostic navigation
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Native undotree (0.12 built-in)
map("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Undotree" })

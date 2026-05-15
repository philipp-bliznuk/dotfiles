vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Open files on the last position",
  group = vim.api.nvim_create_augroup("open-file-last-position", { clear = true }),
  command = [[silent! normal! g`"zv]],
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Change tabstop to 2 spaces for some files",
  group = vim.api.nvim_create_augroup("change-tabstop", { clear = true }),
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Always enable 'spell' on some filetypes",
  group = vim.api.nvim_create_augroup("enable-spell", { clear = true }),
  pattern = {
    "markdown",
  },
  callback = function()
    vim.opt_local.spell = true
  end,
})

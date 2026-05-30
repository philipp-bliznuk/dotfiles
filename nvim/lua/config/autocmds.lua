local autocmd = vim.api.nvim_create_autocmd
local augroup = require("util").augroup

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("config_yank_highlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Restore cursor to last position
autocmd("BufReadPost", {
  group = augroup("config_restore_cursor"),
  callback = function(event)
    local buf = event.buf
    local ft = vim.bo[buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" or ft == "commit" then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd("normal! zv")
    end
  end,
})

-- Auto-resize splits on terminal resize
autocmd("VimResized", {
  group = augroup("config_auto_resize"),
  command = "tabdo wincmd =",
})

-- Close special buffers with q
autocmd("FileType", {
  group = augroup("config_close_with_q"),
  pattern = { "help", "qf", "notify", "checkhealth", "man", "lspinfo", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Check for file changes when focusing nvim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("config_checktime"),
  callback = function()
    if vim.bo.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Auto-create parent directories on save
autocmd("BufWritePre", {
  group = augroup("config_auto_mkdir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return -- skip URLs (fugitive://, oil://, etc.)
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Wrap + linebreak for prose filetypes (spell handled by harper-ls)
autocmd("FileType", {
  group = augroup("config_prose_settings"),
  pattern = { "gitcommit", "markdown", "text", "plaintex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- LspProgress echo (native 0.12)
autocmd("LspProgress", {
  group = augroup("config_lsp_progress"),
  callback = function(event)
    local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
    if not client then
      return
    end
    local value = event.data.params and event.data.params.value
    if value and value.kind == "begin" then
      vim.cmd.redrawstatus()
    end
  end,
})

-- Formatoptions: disable comment continuation, enable useful flags
autocmd("FileType", {
  group = augroup("config_formatoptions"),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove("ro") -- no comment continuation on Enter/o/O
    vim.opt_local.formatoptions:append("tnj") -- auto-wrap, numbered lists, join comments
  end,
})

-- 2-space indent for filetypes whose formatters default to 2 (prettier, stylua)
autocmd("FileType", {
  group = augroup("config_indent_2"),
  pattern = {
    "lua",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "json",
    "jsonc",
    "css",
    "scss",
    "html",
    "yaml",
    "markdown",
  },
  callback = function()
    vim.opt_local.tabstop = 2
  end,
})

-- Fast exit: stop all LSP clients and daemon formatters on quit
autocmd("VimLeavePre", {
  group = augroup("config_lsp_stop"),
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop(true)
    end
    -- Gracefully stop prettierd daemon (if installed)
    if vim.fn.executable("prettierd") == 1 then
      vim.fn.jobstart({ "prettierd", "--stop" }, { detach = true })
    end
  end,
})

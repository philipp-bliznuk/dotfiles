-- Bytecode cache (must be first - before any require)
vim.loader.enable()

-- Built-in plugins off, before any sourcing: the names runtime/plugin/* checks
-- (netrw hands directories to yazi)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Leader must be set before any keymaps or plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core config
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

-- Native 0.12 built-in plugins
pcall(vim.cmd.packadd, "nvim.undotree") -- :Undotree command
pcall(vim.cmd.packadd, "nvim.difftool") -- :DiffTool command

-- Plugin infrastructure
require("config.pack")

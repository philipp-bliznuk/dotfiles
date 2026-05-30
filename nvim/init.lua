-- Bytecode cache (must be first — before any require)
vim.loader.enable()

-- Disable unused built-in plugins (before any sourcing)
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_2html_plugin = 1

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

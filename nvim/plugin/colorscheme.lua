--- Colorscheme: Catppuccin Mocha. Integrations stay at their defaults except mason.
local pack = require("config.pack")

pack.add("https://github.com/catppuccin/nvim", function()
  require("catppuccin").setup({ integrations = { mason = true } })
end)
vim.cmd.colorscheme("catppuccin-mocha")

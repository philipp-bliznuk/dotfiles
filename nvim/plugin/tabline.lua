local pack = require("config.pack")

pack.add("https://github.com/nvim-mini/mini.tabline", function()
  require("mini.tabline").setup()
end)

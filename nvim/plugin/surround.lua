local pack = require("config.pack")

pack.on_event("https://github.com/nvim-mini/mini.surround", {
  event = "BufReadPost",
  config = function()
    require("mini.surround").setup()
  end,
})

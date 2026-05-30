local pack = require("config.pack")

pack.on_event("https://github.com/nvim-mini/mini.indentscope", {
  event = "BufReadPost",
  config = function()
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
      draw = { animation = require("mini.indentscope").gen_animation.none() },
    })
  end,
})

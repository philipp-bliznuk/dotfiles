local pack = require("config.pack")

pack.add("https://github.com/rmagatti/auto-session", function()
  require("auto-session").setup({
    suppressed_dirs = { "~/", "~/projects", "~/Downloads", "/" },
  })
end)

local pack = require("config.pack")

pack.add("https://github.com/rmagatti/auto-session", function()
  require("auto-session").setup({
    suppressed_dirs = { "~/", "~/projects", "~/Downloads", "/" },
    -- nvim <dir> opens yazi (open_for_directories), no session restore over it
    args_allow_single_directory = false,
  })
end)

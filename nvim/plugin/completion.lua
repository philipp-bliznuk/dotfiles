--- Completion engine setup (blink.cmp).
--- Plugin loading happens in lua/config/lsp.lua (before capabilities registration).

require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = {
    documentation = { auto_show = true },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  cmdline = { enabled = true },
  fuzzy = { implementation = "prefer_rust" },
})

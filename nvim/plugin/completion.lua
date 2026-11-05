--- Completion engine setup (blink.cmp).
--- Plugin loading happens in lua/config/lsp.lua (before capabilities registration).

require("blink.cmp").setup({
  completion = {
    documentation = { auto_show = true },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true },
  sources = {
    providers = {
      lsp = { score_offset = 4, fallbacks = {} },
      buffer = { score_offset = 2 },
      path = { score_offset = 0 },
      snippets = { score_offset = -3 },
    },
  },
  fuzzy = { implementation = "prefer_rust" },
})

-- Autopairs: auto-close brackets, quotes, backticks.
-- Handles triple-pairs (""", ''', ```) for Python and Markdown out of the box.
-- blink.cmp's built-in auto_brackets handles function completion parens separately.
local pack = require("config.pack")

pack.on_event("https://github.com/windwp/nvim-autopairs", {
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true, -- treesitter-aware (don't pair inside strings etc.)
      map_cr = true, -- Enter between pairs expands properly
      map_bs = true, -- Backspace deletes both sides of pair
    })
  end,
})

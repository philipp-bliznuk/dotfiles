return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = icons.git.added },
        change = { text = icons.git.modified },
        delete = { text = icons.git.removed },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function set(l, r, desc)
          map("n", l, r, { buffer = bufnr, desc = desc })
        end

        set("<leader>hr", gs.reset_hunk, "Reset hunk")
        set("<leader>hR", gs.reset_buffer, "Reset buffer")
        set("<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
      end,
    },
  },
}

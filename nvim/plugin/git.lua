local pack = require("config.pack")
local map = require("util").map

pack.on_event("https://github.com/lewis6991/gitsigns.nvim", {
  event = "UIEnter",
  config = function()
    require("gitsigns").setup({
      sign_priority = 15, -- above diagnostics (10) so git signs stay innermost
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function bmap(mode, lhs, rhs, desc)
          map(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        bmap("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")
        bmap("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Prev hunk")

        -- Actions
        bmap({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        bmap("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        bmap({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        bmap("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        bmap("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        bmap("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")

        -- Blame
        bmap("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
        bmap("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle inline blame")

        -- Diff
        bmap("n", "<leader>hd", gs.diffthis, "Diff against index")

        -- Text object
        bmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    })
  end,
})

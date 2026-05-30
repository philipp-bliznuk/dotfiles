local pack = require("config.pack")
local map = require("util").map

-----------------------------------------------------------
-- fzf-lua: fuzzy picker (leverages system fzf + fd + rg)
-- Inherits FZF_DEFAULT_OPTS (theme colors, walker-skip)
-----------------------------------------------------------
pack.add("https://github.com/ibhagwan/fzf-lua", function()
  local fzf = require("fzf-lua")

  fzf.setup({
    winopts = {
      preview = { default = "bat" },
    },
    files = {
      fd_opts = "--type f --hidden --exclude .git --exclude .venv --exclude node_modules --exclude .idea --exclude __pycache__ --exclude target --exclude .ruff_cache --exclude .DS_Store",
    },
    grep = {
      rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case"
        .. " -g '!.git/'"
        .. " -g '!.venv/'"
        .. " -g '!node_modules/'"
        .. " -g '!.idea/'"
        .. " -g '!__pycache__/'"
        .. " -g '!target/'"
        .. " -g '!.ruff_cache/'"
        .. " -g '!.DS_Store'",
    },
  })

  -- Override vim.ui.select (code actions, LSP selections go through fzf)
  fzf.register_ui_select()

  local no_preview = { winopts = { preview = { hidden = "hidden" } } }

  -- File finding
  map("n", "<leader>ff", fzf.files, { desc = "Find files" })
  map("n", "<leader>fg", fzf.grep_cword, { desc = "Grep word under cursor" })
  map("n", "<leader>/", fzf.live_grep, { desc = "Live grep" })
  map("n", "<leader>f/", fzf.blines, { desc = "Search current buffer" })
  map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
  map("n", "<leader>fr", fzf.resume, { desc = "Resume last picker" })

  -- Buffers / recent
  map("n", "<leader>fb", function()
    fzf.buffers({ sort_lastused = true })
  end, { desc = "Buffers" })
  map("n", "<leader>f.", function()
    fzf.oldfiles({ cwd_only = true })
  end, { desc = "Recent files (project)" })

  -- Vim (no preview)
  map("n", "<leader>fk", function()
    fzf.keymaps(no_preview)
  end, { desc = "Keymaps" })
  map("n", "<leader>fc", function()
    fzf.commands(no_preview)
  end, { desc = "Commands" })

  -- Git
  map("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
  map("n", "<leader>gl", fzf.git_commits, { desc = "Git log" })
  map("n", "<leader>gS", fzf.git_status, { desc = "Git status" })

  -- Spell suggestions (small window, no preview)
  map("n", "z=", function()
    fzf.spell_suggest({ winopts = { preview = { hidden = "hidden" }, height = 0.4, width = 0.3 } })
  end, { desc = "Spell suggestions" })
end)

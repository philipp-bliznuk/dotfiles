local pack = require("config.pack")
local map = require("util").map

-- Dependencies
pack.add("https://github.com/nvim-lua/plenary.nvim")

-- Yazi file manager (eager - needs BufEnter hook for open_for_directories)
pack.add("https://github.com/mikavilpas/yazi.nvim", function()
  require("yazi").setup({
    open_for_directories = true,
    integrations = {
      grep_in_directory = "fzf-lua",
      grep_in_selected_files = "fzf-lua",
    },
    -- the replace (grug-far) and pick-window (snacks) integrations have no
    -- plugin here: their keys stay unmapped instead of erroring
    keymaps = {
      replace_in_directory = false,
      open_and_pick_window = false,
    },
  })
end)

-- Keymaps: `-` opens the listing around the current file (vinegar/oil
-- convention); the e prefix would hold back <leader>e for timeoutlen.
map("n", "-", "<cmd>Yazi<CR>", { desc = "Yazi at this file" })
map("n", "_", "<cmd>Yazi cwd<CR>", { desc = "Yazi at the working directory" })

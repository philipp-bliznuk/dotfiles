local pack = require("config.pack")
local map = require("util").map

-- Dependencies
pack.add("https://github.com/nvim-lua/plenary.nvim")

-- Yazi file manager (eager — needs BufEnter hook for open_for_directories)
pack.add("https://github.com/mikavilpas/yazi.nvim", function()
  require("yazi").setup({
    open_for_directories = true,
    integrations = {
      grep_in_directory = "fzf-lua",
      grep_in_selected_files = "fzf-lua",
      replace_in_directory = nil,
      replace_in_selected_files = nil,
      pick_window_implementation = nil,
    },
  })
end)

-- Keymaps
map("n", "<leader>ec", "<cmd>Yazi<CR>", { desc = "Explore current dir" })
map("n", "<leader>ep", "<cmd>Yazi cwd<CR>", { desc = "Explore project" })

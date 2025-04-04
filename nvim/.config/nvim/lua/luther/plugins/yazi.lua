return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
      { "<leader>e", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
    },
    opts = {
      yazi_floating_window_border = border,
    },
  },
}

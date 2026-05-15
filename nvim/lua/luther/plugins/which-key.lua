return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 1500,
    spec = {
      { "<leader>f", group = "Find" },
      {
        "<leader>b",
        group = "Buffer",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      { "<leader>r", group = "Rename" },
      { "<leader>g", group = "Go to" },
      { "<leader>c", group = "Code" },
      { "<leader>u", group = "Undo" },
    },
  },
}

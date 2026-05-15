return {
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", config = true },
      { "catppuccin/nvim", name = "catppuccin" },
    },
    event = "VeryLazy",
    opts = function()
      local theme_colors = require("catppuccin.palettes").get_palette("mocha")
      return { colors = theme_colors }
    end,
  },
}

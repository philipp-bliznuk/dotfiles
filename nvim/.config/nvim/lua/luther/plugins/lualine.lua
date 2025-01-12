return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    ---@diagnostic disable-next-line: undefined-field
    require("lualine").setup({
      options = { theme = "catppuccin" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = { "", color = { fg = colors.yellow } } },
          { "diff", symbols = icons.git },
          { "diagnostics", symbols = icons.diagnostic },
        },
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = { "filetype", "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}

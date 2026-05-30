--- Colorscheme: install all 8 themes, load + apply only the active one based on $THEME.
local pack = require("config.pack")

-- Single source of truth: url, colorscheme name, setup function
local themes = {
  ["catppuccin-mocha"] = {
    url = "https://github.com/catppuccin/nvim",
    colorscheme = "catppuccin-mocha",
    setup = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          blink_cmp = true,
          fzf = true,
          gitsigns = true,
          mason = true,
          mini = { enabled = true },
          treesitter = true,
          treesitter_context = true,
        },
      })
    end,
  },
  ["tokyo-night"] = {
    url = "https://github.com/folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    setup = function()
      require("tokyonight").setup({ style = "night", plugins = { all = true } })
    end,
  },
  ["kanagawa"] = {
    url = "https://github.com/rebelot/kanagawa.nvim",
    colorscheme = "kanagawa-wave",
    setup = function()
      require("kanagawa").setup({ compile = false, theme = "wave" })
    end,
  },
  ["gruvbox-dark"] = {
    url = "https://github.com/ellisonleao/gruvbox.nvim",
    colorscheme = "gruvbox",
    setup = function()
      require("gruvbox").setup({})
    end,
  },
  ["rose-pine"] = {
    url = "https://github.com/rose-pine/neovim",
    colorscheme = "rose-pine",
    setup = function()
      require("rose-pine").setup({ dark_variant = "main" })
    end,
  },
  ["everforest"] = {
    url = "https://github.com/neanias/everforest-nvim",
    colorscheme = "everforest",
    setup = function()
      require("everforest").setup({ background = "medium" })
    end,
  },
  ["dracula"] = {
    url = "https://github.com/Mofiqul/dracula.nvim",
    colorscheme = "dracula",
    setup = function()
      require("dracula").setup({ italic_comment = true })
    end,
  },
  ["nord"] = {
    url = "https://github.com/shaunsingh/nord.nvim",
    colorscheme = "nord",
    setup = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_italic = true
    end,
  },
}

-- Load only the active theme plugin (others stay on disk but not :packadd'd)
vim.o.background = "dark"
local name = vim.env.THEME or "catppuccin-mocha"
local theme = themes[name] or themes["catppuccin-mocha"]
pack.add(theme.url)
theme.setup()
vim.cmd.colorscheme(theme.colorscheme)

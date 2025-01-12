return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    opts = {

      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
          border = border,
        },
        documentation = {
          window = { border = border },
          treesitter_highlighting = true,
        },
        list = { max_items = 20 },
      },

      signature = {
        enabled = true,
        window = {
          border = border,
          treesitter_highlighting = true,
        },
      },

      sources = {
        default = { "lsp", "buffer", "path" },
        providers = {
          lsp = { score_offset = 100 },
          buffer = { score_offset = 50 },
          path = { score_offset = 10 },
        },
      },

      keymap = {
        ["<C-y>"] = { "select_and_accept" },

        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["K"] = { "show_documentation", "hide_documentation", "fallback" },
      },
    },
  },
}

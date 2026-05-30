--- Auto-formatting on save via conform.nvim.
--- Uses external formatters (ruff, stylua, prettierd, goimports, etc.)
--- with LSP as fallback for filetypes without a configured formatter.
local pack = require("config.pack")
local util = require("util")

pack.add("https://github.com/stevearc/conform.nvim", function()
  require("conform").setup({
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
      lua = { "stylua" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      go = { "goimports", "gofmt" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      toml = { lsp_format = "prefer" }, -- taplo LSP formatting is excellent
      sql = { "pgformatter" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
      markdown = { "prettierd" },
      dockerfile = { "trim_whitespace" },
      ["_"] = { "trim_whitespace" }, -- catch-all for unspecified filetypes
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = {
        prepend_args = { "-i", "4", "-ci" },
      },
    },
  })

  -- Manual format keymap (works even if format_on_save is somehow skipped)
  util.map({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format buffer" })
end)

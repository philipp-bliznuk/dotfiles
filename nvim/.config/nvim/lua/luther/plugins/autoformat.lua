return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "=",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = "fallback",
        stop_after_first = true,
      },
      format_on_save = {
        timeout_ms = 500,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix ", "ruff_format", "ruff_organize_imports", stop_after_first = false },
        go = { "gofmt" },
        ["*"] = { "codespell" },
      },
    },
  },
}

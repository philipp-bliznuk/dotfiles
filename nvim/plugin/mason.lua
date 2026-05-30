--- Mason: package manager for LSP servers, formatters, and DAPs.
--- Auto-installs all required tools on startup via registry API.
--- No mason-lspconfig needed — we use native vim.lsp.config() + vim.lsp.enable().
local pack = require("config.pack")

pack.add("https://github.com/mason-org/mason.nvim", function()
  require("mason").setup({
    ui = { border = "rounded" },
  })

  -- Map of all tools to auto-install (mason package names).
  local tools = {
    -- LSP servers
    "pyright",
    "ruff",
    "lua-language-server",
    "tsgo",
    "gopls",
    "json-lsp",
    "yaml-language-server",
    "html-lsp",
    "css-lsp",
    "taplo",
    "postgres-language-server",
    "dockerfile-language-server",
    "bash-language-server",
    "harper-ls",
    "typos-lsp",
    -- Formatters (used by conform.nvim)
    "stylua",
    "prettierd",
    "pgformatter",
    "shfmt",
    "goimports",
  }

  -- Defer tool scanning to after UI renders (doesn't block startup)
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("mason_auto_install", { clear = true }),
    once = true,
    callback = function()
      local registry = require("mason-registry")

      -- Re-trigger LSP attach for open buffers when mason finishes installing a package.
      registry:on(
        "package:install:success",
        vim.schedule_wrap(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
              vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
            end
          end
        end)
      )

      -- Fast local check — no network if everything is installed
      local missing = {}
      local unknown = {}
      for _, name in ipairs(tools) do
        local ok, pkg = pcall(registry.get_package, name)
        if ok then
          if not pkg:is_installed() then
            table.insert(missing, name)
          end
        else
          table.insert(unknown, name)
        end
      end

      -- Only refresh registry (network) if there are missing or unknown tools
      if #missing > 0 or #unknown > 0 then
        registry.refresh(function()
          for _, name in ipairs(vim.list_extend(missing, unknown)) do
            local ok, pkg = pcall(registry.get_package, name)
            if ok and not pkg:is_installed() then
              vim.notify("Mason: installing " .. name, vim.log.levels.INFO)
              pkg:install()
            end
          end
        end)
      end
    end,
  })
end)

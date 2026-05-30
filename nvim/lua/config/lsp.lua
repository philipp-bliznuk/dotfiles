--- Global LSP configuration, keymaps, and server activation.
--- All server configs are inline (bracket-assignment registers them in _configs).

local util = require("util")

-- Diagnostics appearance
vim.diagnostic.config({
  severity_sort = true,
  float = {
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󱎘 ",
      [vim.diagnostic.severity.WARN] = "󱈸 ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = "󰙎 ",
    },
  },
  virtual_text = {
    prefix = "",
    spacing = 4,
  },
  underline = true,
  update_in_insert = false,
})

-- Completion engine (must load before LSP for capabilities)
local pack = require("config.pack")
pack.add("https://github.com/rafamadriz/friendly-snippets")
pack.add({ src = "https://github.com/saghen/blink.cmp", version = "v1" })

-- Global defaults inherited by all servers
local blink_ok, blink = pcall(require, "blink.cmp")
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = blink_ok and blink.get_lsp_capabilities() or nil,
})

-- Custom filetype mappings
vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    tmpl = "gotmpl",
  },
  filename = {
    ["Containerfile"] = "dockerfile",
  },
  pattern = {
    ["Containerfile.*"] = "dockerfile",
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
  },
})

-----------------------------------------------------------
-- Server configs
-----------------------------------------------------------

-- Python: type checking, IDE intelligence
vim.lsp.config["pyright"] = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "pyrightconfig.json", "setup.py", "setup.cfg", ".git" },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        disableOrganizeImports = true, -- ruff handles imports
      },
    },
  },
  before_init = function(_, config)
    -- Auto-detect .venv python path by walking up from buffer dir
    local bufname = vim.api.nvim_buf_get_name(0)
    local search_from = bufname ~= "" and vim.fs.dirname(bufname) or config.root_dir
    if not search_from then
      return
    end
    local venv_root = vim.fs.root(search_from, ".venv")
    if not venv_root then
      return
    end
    local venv_python = venv_root .. "/.venv/bin/python"
    if vim.uv.fs_stat(venv_python) then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = venv_python
    end
  end,
}

-- Python: linting (formatting handled by conform via ruff CLI)
vim.lsp.config["ruff"] = {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- Lua: Neovim API support (formatting handled by conform via stylua)
vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- TypeScript / JavaScript (tsgo: Microsoft's Go-based TS server, faster than ts_ls)
-- Formatting handled by conform via prettierd
vim.lsp.config["tsgo"] = {
  cmd = { "tsgo", "--lsp", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "package-lock.json",
    "yarn.lock",
    "pnpm-lock.yaml",
    "bun.lockb",
    "bun.lock",
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}

-- Go
vim.lsp.config["gopls"] = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.sum", ".git" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedvariable = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}

-- JSON
vim.lsp.config["jsonls"] = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}

-- YAML
vim.lsp.config["yamlls"] = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemaStore = { enable = true },
      validate = true,
      format = { enable = true },
      hover = true,
      completion = true,
    },
  },
}

-- HTML
vim.lsp.config["html"] = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
}

-- CSS / SCSS / Less
vim.lsp.config["cssls"] = {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

-- TOML
vim.lsp.config["taplo"] = {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { "taplo.toml", ".taplo.toml", ".git" },
}

-- PostgreSQL
vim.lsp.config["postgres_lsp"] = {
  cmd = { "postgres-language-server", "lsp-proxy" },
  filetypes = { "sql" },
  root_markers = { "postgres-language-server.jsonc", ".git" },
}

-- Dockerfile / Containerfile
vim.lsp.config["dockerls"] = {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", "Containerfile", ".git" },
}

-- Bash / Zsh
vim.lsp.config["bashls"] = {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_markers = { ".git" },
}

-- Grammar and spell checker (code-comment-aware)
vim.lsp.config["harper_ls"] = {
  cmd = { "harper-ls", "--stdio" },
  filetypes = {
    "markdown",
    "text",
    "gitcommit",
    "python",
    "lua",
    "go",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "rust",
    "sh",
    "bash",
    "zsh",
    "toml",
    "yaml",
  },
  root_markers = { ".git" },
  settings = {
    ["harper-ls"] = {
      linters = {
        SpellCheck = true,
        RepeatedWords = true,
        AnA = true,
        SentenceCapitalization = false,
        LongSentences = true,
        UnclosedQuotes = true,
      },
      diagnosticSeverity = "hint",
    },
  },
}

-- Common misspellings in identifiers (attaches to all filetypes)
vim.lsp.config["typos_lsp"] = {
  cmd = { "typos-lsp" },
  root_markers = { "typos.toml", "_typos.toml", ".typos.toml", ".git" },
  init_options = {
    diagnosticSeverity = "hint",
  },
}

-----------------------------------------------------------
-- Enable all configured servers
-----------------------------------------------------------
vim.lsp.enable({
  "pyright",
  "ruff",
  "lua_ls",
  "tsgo",
  "gopls",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  "taplo",
  "postgres_lsp",
  "dockerls",
  "bashls",
  "harper_ls",
  "typos_lsp",
})

-----------------------------------------------------------
-- LspAttach: buffer-local keymaps and features
-----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = util.augroup("lsp_attach"),
  callback = function(event)
    local buf = event.buf
    local client = vim.lsp.get_clients({ id = event.data.client_id })[1]
    if not client then
      return
    end

    -- Separation of concerns: ruff = lint/format only, pyright = everything else
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
      return
    end

    -- LSP navigation via fzf-lua (auto-jump single result, picker on multiple)
    local fzf_ok, fzf = pcall(require, "fzf-lua")
    if fzf_ok then
      util.map("n", "<leader>gd", fzf.lsp_definitions, { buffer = buf, desc = "LSP: Definitions" })
      util.map("n", "<leader>gD", vim.lsp.buf.declaration, { buffer = buf, desc = "LSP: Declaration" })
      util.map("n", "<leader>gr", fzf.lsp_references, { buffer = buf, desc = "LSP: References" })
      util.map("n", "<leader>gi", fzf.lsp_implementations, { buffer = buf, desc = "LSP: Implementations" })
      util.map("n", "<leader>gy", fzf.lsp_typedefs, { buffer = buf, desc = "LSP: Type definitions" })
      util.map("n", "<leader>gs", fzf.lsp_document_symbols, { buffer = buf, desc = "LSP: Document symbols" })
      util.map("n", "<leader>gw", fzf.lsp_live_workspace_symbols, { buffer = buf, desc = "LSP: Workspace symbols" })
      util.map("n", "<leader>gx", fzf.diagnostics_workspace, { buffer = buf, desc = "LSP: Diagnostics" })
    else
      util.map("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "LSP: Go to declaration" })
    end

    -- Inlay hints toggle
    if client:supports_method("textDocument/inlayHint") then
      util.map("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, { buffer = buf, desc = "LSP: Toggle inlay hints" })
    end

    -- Document highlight on CursorHold
    if client:supports_method("textDocument/documentHighlight") then
      local hl_group = util.augroup("lsp_highlight_" .. buf .. "_" .. client.id)
      vim.api.nvim_create_autocmd("CursorHold", {
        group = hl_group,
        buffer = buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = hl_group,
        buffer = buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      "saghen/blink.cmp",

      {
        "j-hui/fidget.nvim",
        opts = {
          progress = {
            display = {
              done_icon = "✓", -- Icon shown when all LSP progress tasks are complete
            },
          },
          notification = {
            window = {
              winblend = 0, -- Background color opacity in the notification window
            },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(mode, keys, func, desc)
            map(mode, keys, func, { desc = desc, buffer = event.buf })
          end
          local builtin = require("telescope.builtin")

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("n", "<leader>gd", builtin.lsp_definitions, "Goto Definition")

          -- Find references for the word under your cursor.
          map("n", "<leader>gr", builtin.lsp_references, "Goto References")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("n", "<leader>gi", builtin.lsp_implementations, "Goto Implementation")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("n", "<leader>gt", builtin.lsp_type_definitions, "Type Definition")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("n", "<leader>gs", builtin.lsp_document_symbols, "Document Symbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("n", "<leader>gw", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("n", "<leader>gD", vim.lsp.buf.declaration, "Goto Declaration")

          -- Highlight word under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end

          -- Disable hover in favor of Pyright
          if client ~= nil and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })

      -- Configure diagnostic
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
            [vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
            [vim.diagnostic.severity.INFO] = icons.diagnostic.info,
            [vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
          },
        },
        virtual_text = {
          prefix = "",
          format = function(diagnostic)
            return ({
              [vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
              [vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
              [vim.diagnostic.severity.INFO] = icons.diagnostic.info,
              [vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
            })[diagnostic.severity] .. diagnostic.message .. " "
          end,
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))

      local servers = {
        ruff = {
          filetypes = { "python" },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
        dockerls = {},
        docker_compose_language_service = {},
        pyright = {
          filetypes = { "python" },
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        jsonls = {},
        sqlls = {},
        yamlls = {},
        bashls = {},
      }

      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "codespell",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}

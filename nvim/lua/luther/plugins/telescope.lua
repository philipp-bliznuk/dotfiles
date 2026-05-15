return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    local ignore_patterns = { "node_modules", ".git", ".venv", ".idea", ".ruff_cache", "__pycache__", "*.pyc" }

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = ignore_patterns,
          hidden = true,
          no_ignore = true,
        },
        live_grep = {
          file_ignore_patterns = ignore_patterns,
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    -- set keymaps
    map("n", "<space>ff", builtin.find_files, { desc = "Find files in cwd" })
    map("n", "<space>fh", builtin.help_tags, { desc = "Find help" })
    map("n", "<space>fw", builtin.live_grep, { desc = "Find string in cwd" })
    map("n", "<space>fg", builtin.grep_string, { desc = "Find string under cursor in cwd" })
    map("n", "<space>fc", builtin.commands, { desc = "Find command" })
    map("n", "<space>fn", function()
      builtin.find_files({ cwd = vim.fn.std_path("config") })
    end, { desc = "Find files in neovim config" })
    map("n", "<space>fd", builtin.diagnostics, { desc = "Find diagnostics" })
    map("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Search in current buffer" })
  end,
}

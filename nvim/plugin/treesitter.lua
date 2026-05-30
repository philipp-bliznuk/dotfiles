-- Treesitter: parser management, textobjects, context, autotag
local pack = require("config.pack")
local util = require("util")

-- ─── Parser Management (arborist.nvim) ──────────────────────────────────────
pack.add("https://github.com/arborist-ts/arborist.nvim", function()
  require("arborist").setup({
    prefer_wasm = false,
    update_cadence = "weekly",
    install_popular = true,
    disable = {
      indent = { "python", "lua" }, -- TS indent broken for single-line nodes; built-in is reliable
    },
  })
end)

-- Force synchronous parse on FileType so textobjects/context work on first keypress.
-- Needed because nvim-treesitter-textobjects doesn't call parser:parse() itself —
-- it relies on the highlighter's async parse which may not finish before first input.
vim.api.nvim_create_autocmd("FileType", {
  group = util.augroup("treesitter_force_parse"),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "" then
      return
    end
    -- Skip large files (>1MB) to avoid UI freeze
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > 1024 * 1024 then
      return
    end
    local parse_ok, parser = pcall(vim.treesitter.get_parser, ev.buf)
    if parse_ok and parser then
      parser:parse()
    end
  end,
})

-- ─── Treesitter Context (sticky function/class header) ──────────────────────
-- Eager-load (parallel to textobjects). Plugin only activates after BufReadPost
-- internally, so loading at startup costs nothing on empty nvim.
pack.add("https://github.com/nvim-treesitter/nvim-treesitter-context", function()
  require("treesitter-context").setup({
    max_lines = 3,
    mode = "cursor",
    trim_scope = "outer",
  })
  util.map("n", "<leader>tc", function()
    require("treesitter-context").toggle()
  end, { desc = "Toggle treesitter context" })
end)

-- ─── Textobjects (selection + movement engine) ──────────────────────────────
-- Load immediately (not deferred) — keymaps must be available on first keypress
pack.add("https://github.com/nvim-treesitter/nvim-treesitter-textobjects", function()
  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")

  -- Selection textobjects
  local sel_maps = {
    { "af", "@function.outer" },
    { "if", "@function.inner" },
    { "ac", "@class.outer" },
    { "ic", "@class.inner" },
    { "aa", "@parameter.outer" },
    { "ia", "@parameter.inner" },
  }
  for _, m in ipairs(sel_maps) do
    util.map({ "x", "o" }, m[1], function()
      select.select_textobject(m[2], "textobjects")
    end, { desc = "TS " .. m[1] })
  end

  -- Movement mappings
  util.map({ "n", "x", "o" }, "]f", function()
    move.goto_next_start("@function.outer", "textobjects")
  end, { desc = "Next function start" })
  util.map({ "n", "x", "o" }, "[f", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end, { desc = "Prev function start" })
  util.map({ "n", "x", "o" }, "]F", function()
    move.goto_next_end("@function.outer", "textobjects")
  end, { desc = "Next function end" })
  util.map({ "n", "x", "o" }, "[F", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end, { desc = "Prev function end" })
  util.map({ "n", "x", "o" }, "]c", function()
    if vim.wo.diff then
      vim.cmd("normal! ]c")
    else
      move.goto_next_start("@class.outer", "textobjects")
    end
  end, { desc = "Next class start / diff change" })
  util.map({ "n", "x", "o" }, "[c", function()
    if vim.wo.diff then
      vim.cmd("normal! [c")
    else
      move.goto_previous_start("@class.outer", "textobjects")
    end
  end, { desc = "Prev class start / diff change" })
end)

-- ─── Autotag (HTML/JSX/Markdown tag management) ─────────────────────────────
-- Load on filetype (only when entering a tag-aware file). markdown = "html" alias
-- is built-in, so tags in markdown work via the markdown filetype trigger.
pack.on_ft("https://github.com/windwp/nvim-ts-autotag", {
  ft = {
    "html",
    "xml",
    "markdown",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
    "tsx",
    "jsx",
  },
  config = function()
    require("nvim-ts-autotag").setup()
  end,
})

local pack = require("config.pack")

-- Icons (filetype icons in statusline + general devicons replacement)
pack.add("https://github.com/nvim-mini/mini.icons", function()
  require("mini.icons").setup()
end)

-- Statusline
pack.add("https://github.com/nvim-mini/mini.statusline", function()
  -- Custom diagnostics section using our glyphs from lsp.lua
  local function section_diagnostics(args)
    if MiniStatusline.is_truncated(args.trunc_width) then
      return ""
    end

    local count = vim.diagnostic.count(0)
    local severity = vim.diagnostic.severity
    local parts = {}

    if (count[severity.ERROR] or 0) > 0 then
      table.insert(parts, "󱎘 " .. count[severity.ERROR])
    end
    if (count[severity.WARN] or 0) > 0 then
      table.insert(parts, "󱈸 " .. count[severity.WARN])
    end
    if (count[severity.INFO] or 0) > 0 then
      table.insert(parts, "󰙎 " .. count[severity.INFO])
    end
    if (count[severity.HINT] or 0) > 0 then
      table.insert(parts, "󰌵 " .. count[severity.HINT])
    end

    return table.concat(parts, " ")
  end

  require("mini.statusline").setup({
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = section_diagnostics({ trunc_width = 75 })
        local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
        local filename = MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
          "%<",
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=",
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search, location } },
        })
      end,
    },
  })
end)

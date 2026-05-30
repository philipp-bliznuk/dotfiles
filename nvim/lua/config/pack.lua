--- vim.pack infrastructure and lazy-loading utilities.
--- Each plugin file in plugin/ uses these helpers to register
--- plugins with deferred loading via autocmds/commands/keymaps.
local M = {}

--- Normalize spec into the list format vim.pack.add expects.
---@param spec string|table Plugin spec (URL string or {src=..., name=..., ...})
---@return table List with one spec element
local function wrap_spec(spec)
  return { spec }
end

--- Sanitize spec into a unique augroup-safe identifier.
--- Uses full URL/src so different orgs with same basename don't collide.
---@param spec string|table
---@return string
local function safe_id(spec)
  local s = type(spec) == "string" and spec or (spec.src or spec.name or "unknown")
  return (s:gsub("[^%w]", "_"))
end

--- Add a plugin that loads immediately (no lazy loading).
--- Thin wrapper around vim.pack.add for consistency.
---@param spec string|table Plugin spec (URL or table with src/name/version)
---@param config? function Optional config function called after adding
function M.add(spec, config)
  vim.pack.add(wrap_spec(spec))
  if config then
    config()
  end
end

--- Add a plugin that loads on specific events.
---@param spec string|table Plugin spec
---@param opts table Options: event (string|table), pattern? (string|table), config? (function)
function M.on_event(spec, opts)
  local events = type(opts.event) == "string" and { opts.event } or opts.event
  local loaded = false

  vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup("pack_" .. safe_id(spec), { clear = true }),
    pattern = opts.pattern or "*",
    once = true,
    callback = function(event)
      if loaded then
        return
      end
      loaded = true
      vim.pack.add(wrap_spec(spec))
      if opts.config then
        opts.config()
      end
      -- Re-trigger the event for the current buffer so the plugin processes it
      vim.api.nvim_exec_autocmds(event.event, {
        buffer = event.buf,
        modeline = false,
      })
    end,
  })
end

--- Add a plugin that loads on specific filetypes.
---@param spec string|table Plugin spec
---@param opts table Options: ft (string|table), config? (function)
function M.on_ft(spec, opts)
  local ft = type(opts.ft) == "string" and { opts.ft } or opts.ft
  M.on_event(spec, {
    event = "FileType",
    pattern = ft,
    config = opts.config,
  })
end

--- Add a plugin that loads on specific commands.
---@param spec string|table Plugin spec
---@param opts table Options: cmd (string|table), config? (function)
function M.on_cmd(spec, opts)
  local cmds = type(opts.cmd) == "string" and { opts.cmd } or opts.cmd
  local loaded = false

  for _, cmd in ipairs(cmds) do
    vim.api.nvim_create_user_command(cmd, function(cmd_opts)
      if not loaded then
        loaded = true
        -- Remove placeholder commands before loading plugin
        for _, c in ipairs(cmds) do
          pcall(vim.api.nvim_del_user_command, c)
        end
        vim.pack.add(wrap_spec(spec))
        if opts.config then
          opts.config()
        end
      end
      -- Execute the original command using structured API
      vim.cmd({
        cmd = cmd,
        args = cmd_opts.fargs,
        bang = cmd_opts.bang,
        range = cmd_opts.range > 0 and { cmd_opts.line1, cmd_opts.line2 } or nil,
      })
    end, {
      bang = true,
      nargs = "*",
      range = true,
      complete = function(_, line)
        -- Load plugin to get real completions
        if not loaded then
          loaded = true
          for _, c in ipairs(cmds) do
            pcall(vim.api.nvim_del_user_command, c)
          end
          vim.pack.add(wrap_spec(spec))
          if opts.config then
            opts.config()
          end
        end
        return vim.fn.getcompletion(line, "cmdline")
      end,
    })
  end
end

--- Add a plugin that loads on specific keymaps.
---@param spec string|table Plugin spec
---@param opts table Options: keys (table of {mode, lhs, rhs?, desc?}), config? (function)
function M.on_keys(spec, opts)
  local loaded = false

  for _, key in ipairs(opts.keys) do
    local mode = key[1] or "n"
    local lhs = key[2]
    local rhs = key[3]
    local desc = key[4] or key.desc

    vim.keymap.set(mode, lhs, function()
      if not loaded then
        loaded = true
        -- Remove all placeholder keymaps
        for _, k in ipairs(opts.keys) do
          pcall(vim.keymap.del, k[1] or "n", k[2])
        end
        vim.pack.add(wrap_spec(spec))
        if opts.config then
          opts.config()
        end
      end
      -- Defer key replay so plugin's mappings are fully registered.
      vim.schedule(function()
        if rhs then
          if type(rhs) == "function" then
            rhs()
          else
            local keys_to_feed = vim.api.nvim_replace_termcodes(rhs, true, true, true)
            vim.api.nvim_feedkeys(keys_to_feed, "m", false)
          end
        else
          -- Re-feed the original key so the plugin's mapping takes over
          local keys_to_feed = vim.api.nvim_replace_termcodes(lhs, true, true, true)
          vim.api.nvim_feedkeys(keys_to_feed, "m", false)
        end
      end)
    end, { desc = desc, noremap = true, silent = true })
  end
end

-- :PackUpdate command + keymap
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.notify("Updating plugins...", vim.log.levels.INFO)
  vim.pack.update()
end, { desc = "Update all vim.pack plugins" })

vim.keymap.set("n", "<leader>pu", "<cmd>PackUpdate<CR>", { noremap = true, silent = true, desc = "Update plugins" })

return M

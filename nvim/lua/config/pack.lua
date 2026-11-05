--- vim.pack infrastructure and lazy-loading utilities.
--- Each plugin file in plugin/ uses these helpers to register
--- plugins eagerly or with deferred loading via autocmds.
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

-- :PackUpdate command + keymap
vim.api.nvim_create_user_command("PackUpdate", function()
  vim.notify("Updating plugins...", vim.log.levels.INFO)
  vim.pack.update()
end, { desc = "Update all vim.pack plugins" })

vim.keymap.set("n", "<leader>pu", "<cmd>PackUpdate<CR>", { silent = true, desc = "Update plugins" })

return M

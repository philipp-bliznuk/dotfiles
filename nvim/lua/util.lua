--- Shared helpers for autocommands and keymaps.

local M = {}

--- Create a named augroup with `clear = true`.
---@param name string
---@return integer augroup_id
function M.augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--- Set a keymap, silent unless opts says otherwise.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? table
function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts or {}, { silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M

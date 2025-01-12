return {
  {
    "mbbill/undotree",
    config = function()
      map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
    end,
  },
}

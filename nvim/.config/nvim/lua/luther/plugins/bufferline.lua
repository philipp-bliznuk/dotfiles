return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
  event = "VeryLazy",
  version = "*",
  config = function()
    require("bufferline").setup({
      ---@diagnostic disable-next-line: different-requires
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
      options = {
        mode = "buffers",
        themable = true,
        separator_style = "thin",
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = false,
        sort_by = "insert_at_end",
      },
    })

    for i = 1, 9 do
      map("n", "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
    end

    map("n", "H", "<cmd>BufferLineCyclePrev<CR>")
    map("n", "L", "<cmd>BufferLineCycleNext<CR>")
    map("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Delete current buffer" })
    map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete Buffers to the Right" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete Buffers to the Left" })
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete other Buffers" })
    map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>")
    map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>")
  end,
}

vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.schedule(function()
      -- If Diffview is open, close it automatically once the commit finishes
      if package.loaded["diffview"] and require("diffview.lib").get_current_view() then
        vim.cmd("DiffviewClose")
      end
    end)
  end,
})

return {
  "sindrets/diffview.nvim",
  dependencies = { "tpope/vim-fugitive" },
  opts = {
    keymaps = {
      file_panel = {
        {
          "n",
          "cc",
          "<cmd>silent tab Git commit -v<CR>",
          { desc = "Commit staged changes in a full tab", silent = true },
        },
      },
    },
  },
}

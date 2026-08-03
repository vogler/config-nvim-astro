-- Auto-close Diffview when saving/closing the commit message buffer
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

-- Plugin Specification
return {
  "sindrets/diffview.nvim",
  dependencies = { "tpope/vim-fugitive" },

  -- Global shortcut to open Diffview (<leader>gv)
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
  },

  opts = {
    keymaps = {
      file_panel = {
        -- Press 'cc' in file tree to commit staged files in a full tab
        { "n", "cc", "<cmd>silent tab Git commit -v -q<CR>", { desc = "Commit staged changes", silent = true } },
        -- Press 'q' anywhere in file tree to close Diffview instantly
        { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
      },
    },
  },
}

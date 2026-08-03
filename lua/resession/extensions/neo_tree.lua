local M = {}

---@param opts resession.Extension.OnSaveOpts
function M.on_save(opts)
  local wins = (opts and opts.tabpage) and vim.api.nvim_tabpage_list_wins(opts.tabpage) or vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "neo-tree" then
      local source = vim.b[buf].neo_tree_source or "filesystem"
      local position = vim.b[buf].neo_tree_position or "left"
      return {
        open = true,
        source = source,
        position = position,
      }
    end
  end
  return { open = false }
end

function M.on_post_load(data)
  if not data then return end
  vim.schedule(function()
    if data.open then
      pcall(require("neo-tree.command").execute, {
        action = "show",
        source = data.source or "filesystem",
        position = data.position or "left",
      })
    else
      pcall(require("neo-tree.command").execute, {
        action = "close",
      })
    end
  end)
end

return M

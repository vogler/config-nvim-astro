-- Resession extension to save and restore Neo-tree visibility state across sessions.
-- This records whether Neo-tree was open when the session was saved, and reopens
-- or closes it accordingly when the session is restored.
-- Note: This does not handle default auto-opening on fresh startup or width checks;
-- that is configured separately via an autocommand (e.g. in lua/plugins/neo-tree.lua).

local M = {}

--- Called by resession when saving a session.
--- Records whether Neo-tree is open in the current tab/window layout.
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

--- Called by resession after loading a session.
--- Restores Neo-tree to open (action = "show") or closed (action = "close").
---@param data? { open: boolean, source?: string, position?: string }
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

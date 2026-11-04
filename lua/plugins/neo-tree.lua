---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.filesystem.filtered_items = {
        hide_gitignored = false,
      }
      opts.window.mappings = {
        -- ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        --["Z"] = "expand_all_subnodes",
      }
      return opts
    end,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        neo_tree_auto_open = {
          {
            event = "VimEnter",
            desc = "Open Neo-tree by default if width > 100",
            callback = function()
              local args = vim.v.argv
              local larg = args[#args]
              -- Do not auto-open when reading from stdin or in diff mode
              if larg == "-" or vim.fn.argv(0) == "-" or vim.opt.diff:get() then
                return
              end
              -- Do not auto-open in headless mode
              if #vim.api.nvim_list_uis() == 0 then
                return
              end
              -- Only auto-open if screen width > 100 columns
              if vim.o.columns <= 100 then
                return
              end

              vim.schedule(function()
                -- If a saved session was restored, respect its saved state
                if package.loaded["resession"] and require("resession").get_current() then
                  return
                end

                -- Check if Neo-tree is already open in current tabpage
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "neo-tree" then
                    return
                  end
                end

                pcall(require("neo-tree.command").execute, {
                  action = "show",
                  source = "filesystem",
                  position = "left",
                })
              end)
            end,
          },
        },
      },
    },
  },
}

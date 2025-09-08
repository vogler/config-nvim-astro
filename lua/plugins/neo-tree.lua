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
}

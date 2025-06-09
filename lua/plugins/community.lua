-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Custom configs for plugins added via ../community.lua

---@type LazySpec
return {
  {
    -- https://github.com/OXY2DEV/markview.nvim/wiki/Configuration
    "OXY2DEV/markview.nvim",
    opts = {
      preview = {
        -- hybrid_modes = {}, -- :Markview HybridDisable; Vim-modes where `hybrid mode` is enabled. Default: "n".
        linewise_hybrid_mode = true, -- Clear lines around the cursor in `hybrid mode`, instead of nodes.
      },
      markdown = {
        list_items = {
          -- enable = false,
          shift_width = 2, -- spaces used for padding and wrapped lines
          -- indent_size = 2,
          -- disable all padding! Default add_padding looks a bit nicer, but too confusing with hybrid mode when a sub-item gets the same indent as its parent...
          marker_minus = { add_padding = false },
          marker_plus = { add_padding = false },
          marker_star = { add_padding = false },
          marker_dot = { add_padding = false }, -- numbered lists
        },
        -- https://github.com/OXY2DEV/markview.nvim/wiki/Presets
        headings = require("markview.presets").headings.arrowed, -- default 'marker' has background color for whole line which is too noisy; slanted was broken; arrowed looks a bit goofy, but at least it's easy to see the level
      },
    },
    require("markview.extras.checkboxes").setup(),
  },
}

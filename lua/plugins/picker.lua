-- I want to easily navigate through picker results without having to resume it with <space>f<cr> and then down/up and enter
-- First added bindings < >f] to resume picker, show, down and confirm, but did not work realiably since results moved around...

--- https://www.reddit.com/r/neovim/comments/1oq58oa/snackspickeritemsnvim_navigate_picker_results/
-- results on left: in picker go to normal mode, <c-w>H to move results to left window to go through them (still requires switching window, down, enter)
-- results on bottom: in picker go to normal mode, <c-q> to send all results to quickfix list (opens as bottom window), then use ]q and [q to navigate them -> works fine but requires remembering to send to quickfix first

--- https://github.com/jackielii/snacks-picker-items.nvim A plugin to navigate picker items from snacks.nvim
---@type LazySpec
return {
  "jackielii/snacks-picker-items.nvim",
  lazy = false, -- Load immediately to cache first picker session
  dependencies = { "folke/snacks.nvim" },
  opts = {},
  keys = {
    { "]p", function() require("snacks-picker-items").navigate(1) end, desc = "Next picker item" },
    { "[p", function() require("snacks-picker-items").navigate(-1) end, desc = "Previous picker item" },
  },
}

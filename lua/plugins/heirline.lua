-- Displays visual mode selection count (lines/characters/block dimensions) in the Heirline statusline.
-- Shows compact info in visual mode:
--   - Visual Line mode (V): e.g. 2L
--   - Visual Block mode (<C-v>): e.g. 4L, 9C
--   - Visual Char mode (v): e.g. 15C (single line) or 2L, 45C (multi-line)
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"

    local selection_count = status.utils.surround("left", "mode_bg", {
      provider = function()
        local mode = vim.fn.mode()
        local line_start = vim.fn.line "v"
        local line_end = vim.fn.line "."
        local lines = math.abs(line_end - line_start) + 1

        -- Visual Line mode (V): show line count only (e.g. 2L)
        if mode == "V" then
          return string.format(" %dL ", lines)
        -- Visual Block mode (<C-v>): show line count and column width using virtcol for virtual screen columns (e.g. 4L, 9C)
        elseif mode == "\22" then
          local col_start = vim.fn.virtcol "v"
          local col_end = vim.fn.virtcol "."
          local cols = math.abs(col_end - col_start) + 1
          return string.format(" %dL, %dC ", lines, cols)
        -- Visual Character mode (v)
        else
          local col_start = vim.fn.virtcol "v"
          local col_end = vim.fn.virtcol "."
          if lines == 1 then
            local chars = math.abs(col_end - col_start) + 1
            -- Single line selection: show character count (e.g. 15C)
            return string.format(" %dC ", chars)
          else
            -- Multi-line selection: calculate total characters across selected lines
            local pos_v = vim.fn.getpos "v"
            local pos_dot = vim.fn.getpos "."
            local l1, c1 = pos_v[2], pos_v[3]
            local l2, c2 = pos_dot[2], pos_dot[3]
            if l1 > l2 or (l1 == l2 and c1 > c2) then
              l1, l2 = l2, l1
              c1, c2 = c2, c1
            end
            local total_chars = 0
            for l = l1, l2 do
              local line_str = vim.fn.getline(l)
              local len = vim.fn.strchars(line_str)
              if l == l1 then
                total_chars = total_chars + math.max(0, len - c1 + 1)
              elseif l == l2 then
                total_chars = total_chars + math.min(len, c2)
              else
                total_chars = total_chars + len
              end
            end
            return string.format(" %dL, %dC ", lines, total_chars)
          end
        end
      end,
      update = { "ModeChanged", "CursorMoved", "CursorMovedI" },
    }, function()
      local mode = vim.fn.mode()
      return mode:find "[vV\22]" ~= nil or mode:find "[sS\19]" ~= nil
    end)

    if opts and opts.statusline then
      table.insert(opts.statusline, 2, selection_count)
    end

    return opts
  end,
}

--- Lazygit (<Leader>gg / <Leader>tl) customization to jump to current buffer
---
--- Optimization: when opening lazygit from a modified file, automatically
--- jump to and focus that file in the Files panel (diff view) instead of
--- leaving the cursor on the repository root.
---
--- How it works:
--- If the active buffer has uncommitted changes, we open lazygit and send
--- keystrokes to its terminal buffer to select the file:
---   1. Filter by filename: `/<filename><CR>`
---   2. Move cursor to the leaf file: `>`
---   3. Clear filter to restore full tree: `<Esc>`
--- We inspect the Lazygit TUI terminal buffer between steps to verify each state
--- transition, avoiding race conditions or arbitrary sleep delays.
--- If the buffer is clean or not a file, lazygit opens normally at root.

--- Returns the absolute file path of the current buffer if it is a normal file.
---@return string? path Absolute path, or nil if not a regular file buffer
local function get_current_file_path()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "" then
    local file = vim.api.nvim_buf_get_name(buf)
    if file ~= "" then return file end
  end
  return nil
end

--- Checks whether the given file has uncommitted changes (staged, unstaged, or untracked).
---@param root string Git root or worktree toplevel directory
---@param rel_path string Relative path from root to target file
---@param worktree table? Optional AstroNvim worktree specification
---@return boolean is_dirty True if git status reports any changes
local function has_uncommitted_changes(root, rel_path, worktree)
  if not root or not rel_path then return false end
  local cmd
  if worktree and worktree.gitdir and worktree.toplevel then
    cmd = { "git", "--work-tree", worktree.toplevel, "--git-dir", worktree.gitdir, "status", "--porcelain", "--", rel_path }
  else
    cmd = { "git", "-C", root, "status", "--porcelain", "--", rel_path }
  end
  local out = vim.fn.system(cmd)
  return vim.v.shell_error == 0 and out ~= nil and out:match "%S" ~= nil
end

--- Reads the item counter (e.g. "2 of 4") from the Files panel border in the Lazygit TUI.
--- Confined strictly between panel [2] (Files) and panel [3] (Local branches) and
--- scanned upwards from the bottom border to avoid false matches with Stash or Branch panels.
---@param term_lines string[] Lines read from the Lazygit terminal buffer
---@return number? current Selected item index
---@return number? total Total items count in panel
local function get_lazygit_tui_files_counter(term_lines)
  local l2, l3
  for i, l in ipairs(term_lines) do
    if l:find "%[2%]" or l:find "Files" then l2 = i end
    if l2 and (l:find "%[3%]" or l:find "branch") then
      l3 = i
      break
    end
  end
  if not l2 then return nil, nil end
  local stop = l3 and (l3 - 1) or #term_lines
  for i = stop, l2, -1 do
    local cur, total = term_lines[i]:match "(%d+) of (%d+)"
    if cur and total then
      return tonumber(cur), tonumber(total)
    end
  end
  return nil, nil
end

--- Sends keystrokes to Lazygit's terminal and checks the TUI state to focus the target file.
---@param term table AstroNvim / ToggleTerm terminal instance
---@param filename string Filename tail (e.g. "lazygit.lua") to search for
local function focus_file_in_lazygit(term, filename)
  if not filename or not term or not term.job_id or term.job_id <= 0 then return end
  local timer = (vim.uv or vim.loop).new_timer()
  local step = 1
  local attempts = 0
  local max_attempts = 150

  local function cleanup()
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
  end

  timer:start(
    10,
    10,
    vim.schedule_wrap(function()
      attempts = attempts + 1
      if not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) or not term.job_id or attempts >= max_attempts then
        cleanup()
        return
      end

      local lines = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, false)
      local cur, total = get_lazygit_tui_files_counter(lines)

      if step == 1 then
        -- Step 1: Wait until Lazygit finishes initial Git scan
        local ready = false
        for _, l in ipairs(lines) do
          if l:find(filename, 1, true) then ready = true break end
        end
        if ready or (cur and total and total > 0) then
          step = 2
          attempts = 0
          vim.fn.chansend(term.job_id, "/" .. filename .. "\r")
        end

      elseif step == 2 then
        -- Step 2: Wait until Lazygit renders Filter Mode
        local has_filter = false
        for _, l in ipairs(lines) do
          if l:find("Filter:", 1, true) or l:find("Exit filter mode", 1, true) then
            has_filter = true
            break
          end
        end
        if has_filter or attempts >= 25 then
          step = 3
          attempts = 0
          vim.fn.chansend(term.job_id, ">")
        end

      elseif step == 3 then
        -- Step 3: Wait until cursor reaches bottom leaf in Files panel (cur == total)
        if cur and total and cur == total and total > 0 then
          step = 4
          attempts = 0
          vim.fn.chansend(term.job_id, "\27")
        elseif attempts >= 25 then
          step = 4
          attempts = 0
          vim.fn.chansend(term.job_id, "\27")
        end

      elseif step == 4 then
        -- Step 4: Wait until filter mode has exited and full tree is restored
        local has_filter = false
        for _, l in ipairs(lines) do
          if l:find("Filter:", 1, true) or l:find("Exit filter mode", 1, true) then
            has_filter = true
            break
          end
        end
        if not has_filter or attempts >= 25 then
          cleanup()
        end
      end
    end)
  )
end

--- Toggles Lazygit floating terminal, focusing current buffer if it has uncommitted changes.
local function toggle_lazygit()
  if vim.fn.executable "lazygit" == 0 then
    vim.notify("lazygit is not installed", vim.log.levels.ERROR)
    return
  end

  local astro = require "astrocore"
  local target_file = get_current_file_path()
  local worktree = astro.file_worktree(target_file)
  local flags = worktree
      and (" --work-tree=%s --git-dir=%s"):format(
        vim.fn.shellescape(worktree.toplevel),
        vim.fn.shellescape(worktree.gitdir)
      )
    or ""

  local root = worktree and worktree.toplevel or (target_file and vim.fs.root(target_file, ".git"))
  local rel_path = (target_file and root) and vim.fs.relpath(root, target_file) or nil
  if rel_path then
    rel_path = rel_path:gsub("\\", "/")
  end

  local is_dirty = rel_path and has_uncommitted_changes(root, rel_path, worktree)
  local filename = target_file and vim.fn.fnamemodify(target_file, ":t") or nil

  local cmd = "lazygit " .. flags
  astro.toggle_term_cmd { cmd = cmd, dir = root, direction = "float" }

  if is_dirty and filename then
    local term = astro.user_terminals
      and astro.user_terminals[cmd]
      and astro.user_terminals[cmd][vim.v.count > 0 and vim.v.count or 1]
    if term and term:is_open() then
      focus_file_in_lazygit(term, filename)
    end
  end
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local maps = opts.mappings
    maps.n["<Leader>gg"] = { toggle_lazygit, desc = "ToggleTerm lazygit" }
    maps.n["<Leader>tl"] = { toggle_lazygit, desc = "ToggleTerm lazygit" }
  end,
}

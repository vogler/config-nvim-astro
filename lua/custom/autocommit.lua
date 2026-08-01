-- Auto commit on file save with modification and creation times for new files
-- `touch .git/autocommit` to enable
-- https://www.perplexity.ai/search/how-to-automatically-commit-wi-DMh7rcBmR4W85tfIxZC2mw#3
local function auto_commit_update_with_times()
  -- Get full path of current buffer
  local fullpath = vim.api.nvim_buf_get_name(0)
  if fullpath == '' then
    return
  end

  -- Only handle normal file buffers
  if vim.bo.buftype ~= '' then
    return
  end

  local file_dir = vim.fs.dirname(fullpath)
  if not file_dir then
    return
  end

  -- Find git root for the file's directory
  local git_root_out = vim.fn.system({ 'git', '-C', file_dir, 'rev-parse', '--show-toplevel' })
  if vim.v.shell_error ~= 0 then
    return
  end
  local git_root = git_root_out:gsub('%s+$', '')
  if git_root == '' then
    return
  end

  -- Check for .git/autocommit marker file in git root
  local marker_path = git_root .. '/.git/autocommit'
  local stat_marker = vim.uv.fs_stat(marker_path)
  if not stat_marker then
    return
  end

  -- Get stat info for the saved file (mtime, birthtime/ctime)
  local stat = vim.uv.fs_stat(fullpath)
  if not stat then
    return
  end
  local mtime = stat.mtime and stat.mtime.sec or nil
  local birthtime = (stat.birthtime and stat.birthtime.sec > 0 and stat.birthtime.sec)
    or (stat.ctime and stat.ctime.sec or nil)

  -- Get path relative to git root for clean commit messages
  local relpath = fullpath
  if fullpath:sub(1, #git_root) == git_root then
    relpath = fullpath:sub(#git_root + 2)
  end

  -- Check if file is tracked in git
  vim.fn.system({ 'git', '-C', git_root, 'ls-files', '--error-unmatch', '--', fullpath })
  local is_tracked = (vim.v.shell_error == 0)

  -- Base commit message
  local msg = 'update ' .. relpath

  -- For newly committed (untracked) files, append description with times
  if not is_tracked and mtime then
    local mtime_str = os.date('%Y-%m-%d %H:%M:%S', mtime)
    local desc = 'last modified: ' .. mtime_str
    if birthtime and birthtime ~= mtime then
      local birthtime_str = os.date('%Y-%m-%d %H:%M:%S', birthtime)
      desc = desc .. '; created: ' .. birthtime_str
    end
    msg = msg .. '\n\n' .. desc
  end

  -- Run `git add` followed by `git commit` using direct array args (no shell escaping / multiline issues)
  vim.fn.jobstart({ 'git', '-C', git_root, 'add', '--', fullpath }, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.fn.jobstart({ 'git', '-C', git_root, 'commit', '-m', msg }, { detach = true })
      end
    end,
  })
end

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*',
  callback = auto_commit_update_with_times,
})

-- Auto commit on file save with modification and creation times for new files
-- `touch .git/autocommit` to enable
-- https://www.perplexity.ai/search/how-to-automatically-commit-wi-DMh7rcBmR4W85tfIxZC2mw#3
local function auto_commit_update_with_times()
  -- Check for .git/autocommit marker file
  local marker_path = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('%s+', '') .. '/.git/autocommit'
  local marker_exists = vim.uv.fs_stat(marker_path) ~= nil
  if not marker_exists then
    return
  end

  -- Only run if we're inside a git repo
  local is_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):gsub('%s+', '')
  if is_git_repo ~= 'true' then
    return
  end

  local file = vim.fn.expand('%')
  if file == '' then
    return
  end

  -- Get full path and stat info (mtime, ctime)
  local fullpath = vim.api.nvim_buf_get_name(0)
  local stat = vim.uv.fs_stat(fullpath)
  if not stat then
    return
  end
  local mtime = stat.mtime and stat.mtime.sec or nil
  local ctime = stat.ctime and stat.ctime.sec or nil

  -- Check if file is tracked in git
  vim.fn.system('git ls-files --error-unmatch ' .. vim.fn.shellescape(file) .. ' 2>/dev/null')
  local is_tracked = vim.v.shell_error == 0  -- exit code 0 means tracked

  -- Base commit message
  local msg = 'update ' .. file

  -- For newly committed (untracked) files, append description with times
  if not is_tracked and mtime then
    local mtime_str = os.date('%Y-%m-%d %H:%M:%S', mtime)
    local desc = 'last modified: ' .. mtime_str
    if ctime and ctime ~= mtime then
      local ctime_str = os.date('%Y-%m-%d %H:%M:%S', ctime)
      desc = desc .. '; created: ' .. ctime_str
    end
    msg = msg .. '\n\n' .. desc
  end

  vim.fn.jobstart(
    {
      'sh', '-c',
      'git add ' .. vim.fn.shellescape(file) ..
      ' && git commit -m ' .. vim.fn.shellescape(msg)
    },
    { detach = true }
  )
end

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*',
  callback = auto_commit_update_with_times,
})

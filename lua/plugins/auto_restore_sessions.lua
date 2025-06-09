-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will restore the previous session if nvim is called without positional arguments.
-- See https://docs.astronvim.com/recipes/sessions/#automatically-restore-previous-session
-- Fixed above to not restore session for `echo foo | v -` (piped stdin).

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      -- disable alpha autostart
      alpha_autostart = false,
      restore_session = {
        {
          event = "VimEnter",
          desc = "Restore previous directory session if neovim opened with no arguments",
          nested = true, -- trigger other autocommands as buffers open
          callback = function()
            -- print(vim.inspect(vim.fn.argv())) -- only positional arguments (files to edit), but does not include - (read from stdin)
            -- print(vim.inspect(vim.v.argv)) -- all processed command-line arguments (including options)
            local args = vim.v.argv
            local larg = args[#args] -- last argument
            -- Only load the session if nvim was started without positional arguments (including -)
            if vim.fn.argc(-1) == 0 and larg ~= "-" then
              -- try to load a directory session using the current working directory
              require("resession").load(
                vim.fn.getcwd(),
                { dir = "dirsession", silence_errors = true }
              )
            end
          end,
        },
      },
    },
  },
}

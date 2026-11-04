-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- ][ to jump through errors, warnings etc.; virtual_text is at the end of line (may only fit a few words and is then cut off), virtual_lines is in a new line below (a bit nicer to spot underlined location), but added virtual line may be confusing and does not show anything if there are multiple diagnostics in a line
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        -- signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
        scrolloff = 3,
        autoread = true, -- automatically reload files changed outside of Neovim
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        netrw_silent = 1, -- no "Press ENTER or type command to continue" when editing a file via scp, e.g. nvim scp://pi@rpi3.voglerr.de/dash.log
      },
    },
    -- Configure autocommands through AstroCore
    -- Note: If you want instant real-time reloading for unfocused open splits without needing cursor or focus events, consider https://github.com/diegok/live-autoread.nvim
    autocmds = {
      restore_remote_cursor = {
        {
          event = "BufReadPost",
          pattern = { "scp://*", "sftp://*", "ftp://*", "rcp://*", "rsync://*", "dav://*", "davs://*" },
          desc = "Restore last cursor position for remote netrw files from shada",
          callback = function(args)
            pcall(vim.cmd.rshada, { bang = true })
            local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
            if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end,
        },
      },
      auto_checktime = {
        {
          event = { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose" },
          desc = "Automatically check if files changed on disk",
          callback = function()
            if vim.fn.getcmdwintype() == "" then
              vim.cmd "checktime"
            end
          end,
        },
        {
          event = "FileChangedShellPost",
          desc = "Notify when a file is automatically reloaded from disk",
          callback = function(args)
            vim.notify(
              string.format("File reloaded from disk: %s", vim.fn.fnamemodify(args.file, ":t")),
              vim.log.levels.INFO,
              { title = "Auto-Reload" }
            )
          end,
        },
        {
          event = "FileChangedShell",
          desc = "Warn when a file changed on disk but has unsaved local changes",
          callback = function(args)
            vim.notify(
              string.format("File changed on disk, but has unsaved changes: %s", vim.fn.fnamemodify(args.file, ":t")),
              vim.log.levels.WARN,
              { title = "File Conflict" }
            )
          end,
        },
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- tables with just a `desc` key will be registered with which-key if it's installed; this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        ["-"] = { function() require("neo-tree.command").execute({ action = "focus", position = "current" }) end, desc = "Open Neotree in current window (netrw style)" },
        -- navigate buffer tabs (expr = false prevents plugins like sidekick-nvim from leaking expr = true and triggering E565)
        ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer", expr = false },
        ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer", expr = false },

        -- missing insert blank lines above/below w/o leaving normal mode like in https://github.com/tpope/vim-unimpaired
        -- copied from lua port: https://github.com/tummetott/unimpaired.nvim
        ["[<Space>"] = { function()
          local repeated = vim.fn["repeat"]({""}, vim.v.count1)
          local line = vim.api.nvim_win_get_cursor(0)[1]
          vim.api.nvim_buf_set_lines(0, line-1, line-1, true, repeated)
        end, desc = "Add blank line above" },
        ["]<Space>"] = { function()
          local repeated = vim.fn["repeat"]({""}, vim.v.count1)
          local line = vim.api.nvim_win_get_cursor(0)[1]
          vim.api.nvim_buf_set_lines(0, line, line, true, repeated)
        end, desc = "Add blank line below" },

        -- paste as line above/below
        ["[P"] = { ":put! +<CR>", desc = "Paste as line above" },
        ["]P"] = { ":put +<CR>", desc = "Paste as line below" },

        -- did not work to map go to gx when using mini-operators
        -- ["go"] = { "gx", desc = "Open filepath or URI under cursor" }
        -- https://www.reddit.com/r/neovim/comments/161lm0k/how_to_remap_gx/
        -- maybe use this: https://github.com/chrisgrieser/nvim-various-textobjs#smarter-gx
      },
      i = {
        -- missing readline keybindings in insert mode like in https://github.com/tpope/vim-rsi
        -- no need for https://github.com/assistcontrol/readline.nvim
        ["<C-a>"] = { "<C-o>^", desc = "Start of line" },
        ["<C-e>"] = { "<C-o>$", desc = "End of line" },
        ["<C-k>"] = { "<C-o>C", desc = "Change line" },
      },
      v = {
        -- https://stackoverflow.com/questions/676600/vim-search-and-replace-selected-text/5925566#5925566
        -- vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
        ["<C-r>"] = { "\"hy:%s/<C-r>h//gc<left><left><left>", desc = "Replace visual selection in file (with confirmation)." },
      }
    },
  },
}

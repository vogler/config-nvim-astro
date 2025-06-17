-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- repository: https://github.com/AstroNvim/astrocommunity
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder

  { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.dracula-nvim" },
  { import = "astrocommunity.colorscheme.gruvbox-nvim" },
  -- { import = "astrocommunity.colorscheme.night-owl-nvim" },
  -- { import = "astrocommunity.colorscheme.nord-nvim" },
  { import = "astrocommunity.colorscheme.onedarkpro-nvim" },
  { import = "astrocommunity.colorscheme.solarized-osaka-nvim" },
  { import = "astrocommunity.colorscheme.sonokai" },
  { import = "astrocommunity.colorscheme.tokyodark-nvim" },

  -- https://github.com/HakonHarnes/img-clip.nvim
  { import = "astrocommunity.media.img-clip-nvim" }, -- <Leader>P to :PasteImage from clipboard (saves to assets/2025-06-17-15-40-53.png), supports drag and drop
  { import = "astrocommunity.media.vim-wakatime" },
  -- { import = "astrocommunity.color.headlines-nvim" },

  -- { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.peek-nvim" }, -- :PeekOpen: Error: module not found
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- https://github.com/OXY2DEV/markview.nvim normal-mode/hybrid/split preview for Markdown, Typst, LaTeX, HTML
  { import = "astrocommunity.markdown-and-latex.markview-nvim" }, -- :Markview (no subcmd: Toggle = preview globally), toggle (only buffer) splitToggle (preview in right vsplit), HybridDisable (disable hybrid mode (disables preview for node/line under cursor) since it changes indentation when moving around, w/o it will just show the raw text inline with the preview (no preview in insert mode anyway))

  -- { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.file-explorer.oil-nvim" }, -- <Leader>O
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },

  -- can stage hunks/buffer with <Leader>gs/S or via lazygit, but commit in lazygit is not great since the commit modal covers the staged changes; see https://github.com/jesseduffield/lazygit/discussions/4433#discussioncomment-13393080
  -- was using https://github.com/tpope/vim-fugitive in my old .vimrc with the following:
    -- " just commit what is already staged
    -- nmap <leader>c :Git commit -v --quiet<cr>
    -- " stage file and commit
    -- nmap <leader>C :Gwrite<cr>:Git commit -v --quiet<cr>
  -- vim-fugitive is not available in astrocommunity (only lua)
  -- nice overview of options: https://github.com/sindrets/diffview.nvim/blob/main/USAGE.md#committing
  -- want: commit tab with message top left, git log bottom left, changes right

  -- https://github.com/pwntester/octo.nvim GitHub issues/PRs
  { import = "astrocommunity.git.octo-nvim" }, -- <Leader>O
  -- https://github.com/NeogitOrg/neogit :Neogit has nice status tab, commit tab has split w/ message on top and changes on bottom
  { import = "astrocommunity.git.neogit" }, -- <Leader>gnt for default status tab (:Neogit), <Leader>gnc for commit page
  -- https://github.com/SuperBo/fugit2.nvim by default uses floating window with branches, files, and commits - has nice menus and hotkeys, but not that great to use due to small UI and too many keys to press; prefer tab like diffview.nvim but preferably with git log to see/search commit messages
  -- https://github.com/SuperBo/fugit2.nvim/wiki/%E2%8C%A8%EF%B8%8F-Usage-and-Keymap
  -- { import = "astrocommunity.git.fugit2-nvim" }, -- <Leader>gF; but also adds <Leader>gn for new commit
  -- https://github.com/sindrets/diffview.nvim
  { import = "astrocommunity.git.diffview-nvim" }, -- :DiffviewOpen, :DiffviewFileHistory %
  -- https://github.com/isakbm/gitgraph.nvim
  -- { import = "astrocommunity.git.gitgraph-nvim" }, -- <Leader>g| - uses diffview for commits, but can't use like this since it replaces buffer instead of opening a float; also neogit's log graph is basically the same except that it doesn't use diffview, i.e. no syntax highlighting
  -- https://github.com/chrisgrieser/nvim-tinygit some nice ideas, but UI not great
  -- { import = "astrocommunity.git.nvim-tinygit" }, -- <Leader>gn for new smart commit, <Leader>gP for push

  -- https://github.com/Zeioth/compiler.nvim also uses overseer, but has defaults to run file/program for many languages, and nice UI with trace with adjustable detail
  { import = "astrocommunity.code-runner.compiler-nvim" }, -- :CompilerOpen, :CompilerRedo, :CompilerToggleResults
  -- https://github.com/stevearc/overseer.nvim more basic? no language defaults, just lists e.g. npm run scripts, but has watch mode to rerun task on save
  { import = "astrocommunity.code-runner.overseer-nvim" }, -- <Leader>M for :Overseer{Toggle,RunCmd,Run,QuickAction,TaskAction,Info}

  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },

  -- { import = "astrocommunity.utility.nvim-toggler" }, -- <Leadeer>i to toggle word under cursor (defaults: true/false, yes/no, on/off, enable/disable, left/right, up/down, !=/==)
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  -- { import = "astrocommunity.motion.mini-move" }, -- alternative to the above?
  -- { import = "astrocommunity.editing-support.mini-operators" }, -- g= to evaluate, gx to exchange, gm to multiply, gr to replace, gs to sort; gx clashes with open URL -> remapped to go in astrocore.lua
  -- https://github.com/jake-stewart/multicursor.nvim
  -- { import = "astrocommunity.editing-support.multiple-cursors-nvim" }, -- <Leader>mj to add next match, ma to add all matches; which-key did not show anymore on <Leader> (but for other keys) after using this once

  { import = "astrocommunity.motion.before-nvim" }, -- [e ]e to go through edit locations
  -- { import = "astrocommunity.motion.flash-nvim" }, -- 
  -- { import = "astrocommunity.motion.harpoon" }, -- <Space><Space>a to add mark, e to show menu, <C-p> and <C-n> to go through marks, <C-x> (clash with decrease number) to go to index of mark
  { import = "astrocommunity.motion.marks-nvim" }, -- shows marks in signcolumn, m; to toggle mark at current line (lowercase alpha), m] and m[ to go through marks, 'a to jump to mark a, dm<space> to delete all marks in buffer, uppercase marks for jumping accross buffers
  { import = "astrocommunity.motion.nvim-spider" }, -- change w, e, b to move by subwords and skip insignificant punctuation
  { import = "astrocommunity.motion.nvim-surround" }, -- add: ys{motion}{char}, del: ds{char}, change: cs{from}{to}
  -- { import = "astrocommunity.motion.nvim-tree-pairs" }, -- change % to jump between treesitter nodes and only fallback to syntactic mode if treesitter not available
  { import = "astrocommunity.motion.vim-matchup" }, -- same as above but also jumps between text?
  -- { import = "astrocommunity.motion.portal-nvim" }, -- <Leader>o and i to show preview portal of where to jump
  { import = "astrocommunity.motion.tabout-nvim" }, -- <Tab> and <S-Tab> in insert mode to tab out from parens, quotes etc.

  -- https://github.com/Zeioth/garbage-day.nvim Garbage collector that stops inactive LSP clients to free RAM
  { import = "astrocommunity.lsp.garbage-day-nvim" },

  -- { import = "astrocommunity.pack.bash" },
  -- { import = "astrocommunity.pack.typescript" },
  -- { import = "astrocommunity.pack.json" },
  -- { import = "astrocommunity.pack.yaml" },
  -- -- { import = "astrocommunity.pack.html-css" },
  -- { import = "astrocommunity.pack.tailwindcss" },
  -- { import = "astrocommunity.pack.markdown" },
  -- { import = "astrocommunity.pack.docker" },
  -- { import = "astrocommunity.pack.rainbow-delimiter-indent-blankline" },
}

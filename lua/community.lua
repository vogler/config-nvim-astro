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

  { import = "astrocommunity.media.vim-wakatime" },
  -- { import = "astrocommunity.color.headlines-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.glow-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.peek-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.file-explorer.oil-nvim" }, -- <Leader>O
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },
  -- { import = "astrocommunity.git.octo-nvim" }, -- <Leader>O
  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },

  { import = "astrocommunity.utility.nvim-toggler" },
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  -- { import = "astrocommunity.motion.mini-move" }, -- alternative to the above?
  -- { import = "astrocommunity.editing-support.mini-operators" }, -- g= to evaluate, gx to exchange, gm to multiply, gr to replace, gs to sort; gx clashes with open URL -> remapped to go in astrocore.lua

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

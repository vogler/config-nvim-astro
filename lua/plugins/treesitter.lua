if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true, -- enable/disable treesitter based highlighting
      indent = true, -- enable/disable treesitter based indentation
      auto_install = true, -- enable/disable automatic installation of detected languages
      ensure_installed = {
        "lua",
        "vim",
        "html",
        "arduino",
        "bash",
        "c",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "git_config",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "javascript",
        "json",
        "jsonc",
        "just",
        "latex",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "requirements",
        "ruby",
        "rust",
        "sql",
        "typescript",
        "vimdoc",
        "xml",
        "yaml",
        -- add more arguments for adding more treesitter parsers
      },
    },
  },
}

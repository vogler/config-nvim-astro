-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

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
        -- add more arguments for adding more treesitter parsers
        "arduino",
        "bash",
        "c",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "ecma",
        "git_config",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "html",
        "html_tags",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "jsx",
        "just",
        "latex",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "requirements",
        "ruby",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },
}

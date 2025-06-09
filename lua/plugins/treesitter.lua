if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
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
}

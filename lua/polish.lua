if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- https://github.com/microsoft/typescript-go#what-works-so-far
-- https://www.reddit.com/r/neovim/comments/1kk63nb/typescript_go_lsp/
vim.lsp.config("tsgo", {
    cmd = { "tsgo", "--lsp", "-stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})
vim.lsp.enable("tsgo")

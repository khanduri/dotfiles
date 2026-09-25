if not vim.lsp.config or not vim.lsp.enable then return end
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
local servers = {
  pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" } },
  tsc = { cmd = { "tsc", "--lsp", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" } },
  gopls = { cmd = { "gopls" }, filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = { gopls = { staticcheck = true, hints = { parameterNames = true, assignVariableTypes = true } } } },
  lua_ls = { cmd = { "lua-language-server" }, filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false }, telemetry = { enable = false } } } },
}
for name, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(name, config)
  if vim.fn.executable(config.cmd[1]) == 1 then
    local supported = true
    if name == "tsc" then
      local result = vim.system({ "tsc", "--version" }, { text = true }):wait(2000)
      supported = result.code == 0 and (tonumber((result.stdout or ""):match("Version (%d+)")) or 0) >= 7
    end
    if supported then vim.lsp.enable(name) end
  end
end
local group = vim.api.nvim_create_augroup("DotfilesLsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(ev)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gi", vim.lsp.buf.implementation, "Implementation")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<F2>", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
    map("<leader>cf", function() vim.lsp.buf.format({ async = false, timeout_ms = 2000 }) end, "Format buffer")
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group, pattern = "*.go",
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = "gopls" }) > 0 then
      vim.lsp.buf.format({ bufnr = ev.buf, name = "gopls", async = false, timeout_ms = 2000 })
    end
  end,
})

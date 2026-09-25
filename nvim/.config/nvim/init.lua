-- Load by absolute path from a private init without changing directories.
if vim.g.dotfiles_nvim_loaded then return end
vim.g.dotfiles_nvim_loaded = true
local source = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(vim.uv.fs_realpath(source) or source, ":h")
local function load(name) return dofile(root .. "/lua/dotfiles/" .. name .. ".lua") end
load("settings")
load("plugins")(root)
load("lsp")

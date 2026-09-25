return function(root)
  local base = vim.fn.stdpath("data") .. "/dotfiles"
  local lazy = base .. "/lazy/lazy.nvim"
  local state = vim.fn.stdpath("state") .. "/dotfiles"
  local function setup(installing)
    if not vim.uv.fs_stat(lazy .. "/lua/lazy/init.lua") then return false end
    vim.opt.rtp:prepend(lazy)
    if package.loaded["lazy.core.config"] and require("lazy.core.config").plugins then
      return true -- Respect a plugin manager already initialized by the caller.
    end
    vim.fn.mkdir(state, "p", 448)
    local spec = {
      { "folke/tokyonight.nvim", lazy = false, priority = 1000,
        opts = { style = "night", styles = { comments = { italic = true }, keywords = { italic = false } } },
        config = function(_, options)
          require("tokyonight").setup(options)
          vim.cmd.colorscheme("tokyonight-night")
        end },
      { "folke/snacks.nvim", lazy = false, priority = 900,
        opts = { picker = { enabled = true }, explorer = { enabled = true } },
        keys = {
          { "<leader>f", function() Snacks.picker.files({ hidden = true }) end, desc = "Find files" },
          { "<leader>fg", function() Snacks.picker.grep({ hidden = true }) end, desc = "Search project" },
          { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Search word" },
          { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find buffer" },
          { "<leader>fh", function() Snacks.picker.help() end, desc = "Find help" },
          { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume picker" },
          { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
          { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
          { "<leader>tr", function() Snacks.explorer() end, desc = "File explorer" },
        } },
      { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
      { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" },
        cond = vim.fn.executable("git") == 1, opts = {} },
      { "saghen/blink.cmp", version = "1.*", event = "InsertEnter",
        opts = {
          keymap = { preset = "default" },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            providers = { snippets = { opts = {
              search_paths = { root .. "/dotfiles-snippets", vim.fn.stdpath("config") .. "/snippets" },
            } } },
          },
          fuzzy = { implementation = "lua" },
        } },
    }
    -- Pin reviewed versions; Lazy's writable state never lives in this checkout.
    local lockpath = root .. "/plugin-lock.json"
    if vim.fn.filereadable(lockpath) == 1 then
      local lock = vim.json.decode(table.concat(vim.fn.readfile(lockpath), "\n"))
      for _, plugin in ipairs(spec) do
        local name = plugin[1]:match("[^/]+$")
        if lock[name] then plugin.commit = lock[name].commit end
      end
    end
    vim.list_extend(spec, vim.g.dotfiles_extra_plugins or {})
    if not installing then
      for _, plugin in ipairs(spec) do
        if not vim.uv.fs_stat(base .. "/lazy/" .. plugin[1]:match("[^/]+$")) then return false end
      end
    end
    require("lazy").setup(spec, {
      root = base .. "/lazy", lockfile = state .. "/lazy-lock.json",
      local_spec = false, rocks = { enabled = false }, install = { missing = installing or false },
      checker = { enabled = false }, change_detection = { enabled = false },
      performance = { reset_packpath = false, rtp = { reset = false } },
    })
    return true
  end
  vim.api.nvim_create_user_command("DotfilesInstall", function()
    if vim.fn.executable("git") ~= 1 then
      return vim.notify("Install git first", vim.log.levels.ERROR)
    end
    if not vim.uv.fs_stat(lazy) then
      local output = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazy })
      if vim.v.shell_error ~= 0 then return vim.notify(output, vim.log.levels.ERROR) end
    end
    local lock = vim.json.decode(table.concat(vim.fn.readfile(root .. "/plugin-lock.json"), "\n"))
    if lock["lazy.nvim"] then
      local output = vim.fn.system({ "git", "-C", lazy, "checkout", "--detach", lock["lazy.nvim"].commit })
      if vim.v.shell_error ~= 0 then return vim.notify(output, vim.log.levels.ERROR) end
    end
    if setup(true) then require("lazy").install({ wait = true }) end
  end, { desc = "Install the public Neovim plugins", force = true })
  if not setup() then
    vim.schedule(function() vim.notify("Run :DotfilesInstall once to install plugins. Core settings are active.") end)
  end
end

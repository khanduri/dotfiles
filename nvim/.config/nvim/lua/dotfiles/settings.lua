vim.g.mapleader = ","
vim.g.maplocalleader = ","
local opts = {
  history = 1000, autowrite = true, number = true, relativenumber = true,
  numberwidth = 1, colorcolumn = "80", title = true, scrolloff = 7,
  shiftround = true, hidden = true, cursorline = true, mouse = "a",
  timeoutlen = 500, showmatch = true, errorbells = false, visualbell = false,
  incsearch = true, hlsearch = true, ignorecase = true, smartcase = true,
  termguicolors = true, background = "dark", laststatus = 2,
  tabstop = 4, softtabstop = 4, shiftwidth = 4, textwidth = 120,
  smarttab = true, expandtab = true, linebreak = true, autoindent = true,
  smartindent = true, wrap = true, backup = false, writebackup = false,
  swapfile = false, undofile = true, undolevels = 1000, undoreload = 10000,
  wildignore = "*.swp,*.bak,*.pyc,*.class", wildmode = "longest:full,full",
  completeopt = "menu,menuone,noselect", signcolumn = "yes",
  statusline = "%f %h%m%r%=%y %l:%c %p%%",
}
for key, value in pairs(opts) do vim.opt[key] = value end
if vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1 then
  vim.opt.clipboard = "unnamedplus"
end
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(vim.o.undodir, "p", 448)
vim.opt.statuscolumn = "%s%3{v:lnum}│%2{v:relnum==0?'':v:relnum} "
local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end
map("<leader>r", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", "Replace word")
map("<leader>v", "<cmd>vsplit<cr>", "Vertical split")
map("<leader>s", "<cmd>split<cr>", "Horizontal split")
for _, direction in ipairs({ "h", "j", "k", "l" }) do
  map("<leader>" .. direction, "<C-w>" .. direction, "Focus " .. direction)
end
map("<leader>1", "<cmd>resize +5<cr>", "Taller window")
map("<leader>2", "<cmd>resize -5<cr>", "Shorter window")
map("<leader>3", "<cmd>vertical resize +5<cr>", "Wider window")
map("<leader>4", "<cmd>vertical resize -5<cr>", "Narrower window")
map("<leader>/", "<cmd>bnext<cr>", "Next buffer")
map("<leader>.", "<cmd>bprevious<cr>", "Previous buffer")
map("<leader>`", "<cmd>bdelete<cr>", "Delete buffer")
map("<leader>p", function() print(vim.fn.expand("%:p")) end, "File path")
map("<leader>za", "<cmd>set foldmethod=indent<cr>", "Indent folds")
map("<leader>zz", "<cmd>set foldlevel=99<cr>", "Open folds")
map("<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
vim.api.nvim_create_user_command("BD", "bprevious | split | bnext | bdelete", { force = true })
local group = vim.api.nvim_create_augroup("DotfilesEditing", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group, pattern = { "markdown", "python" },
  callback = function(ev)
    vim.bo[ev.buf].spelllang = "en_us"
    vim.wo.spell = true
    if vim.bo[ev.buf].filetype == "markdown" then vim.bo[ev.buf].textwidth = 0 end
    if vim.bo[ev.buf].filetype == "python" then
      vim.keymap.set("n", "<F5>", function()
        if vim.fn.executable("python3") ~= 1 then
          return vim.notify("python3 is not installed", vim.log.levels.WARN)
        end
        vim.cmd.write()
        vim.cmd("!python3 " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
      end, { buffer = ev.buf, desc = "Run Python file" })
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group, pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "lua" },
  callback = function(ev)
    for _, option in ipairs({ "tabstop", "softtabstop", "shiftwidth" }) do vim.bo[ev.buf][option] = 2 end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = group, pattern = { "html", "css" },
  callback = function(ev) vim.bo[ev.buf].textwidth = 0 end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "markdown" or vim.bo[ev.buf].buftype ~= "" or not vim.bo[ev.buf].modifiable then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

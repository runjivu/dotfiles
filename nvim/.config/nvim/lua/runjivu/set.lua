-- vim.opt.guicursor = { 'a:grey' }

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

-- fuck backups and swps
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'
vim.g.mapleader = ' '

vim.api.nvim_exec ('language en_US', true)
vim.cmd([[
  let $LC_CTYPE = 'en_US.UTF-8'
]])

vim.opt.mouse = "a"
vim.opt.clipboard="unnamedplus"


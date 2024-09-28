vim.api.nvim_exec ('language en_US', true)
vim.cmd([[
  let $LC_CTYPE = 'en_US.UTF-8'
]])
require("runjivu.remap")
require("runjivu.set")
require("runjivu.packer")
require("runjivu.pyright")
vim.opt.mouse = ""
vim.opt.clipboard="unnamedplus"

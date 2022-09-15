vim.g.mapleader = ' '
vim.g.ttyfast = true
vim.g.noswapfile = true

vim.o.termguicolors = true
vim.opt.clipboard:append { 'unnamedplus' }

-- vim.updatetime = 40
vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd([[let g:test#python#runner = "nose"]])

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.signcolumn = 'yes'

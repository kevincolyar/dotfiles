-- 'set' command in vim are the same as 'vim.opt'
-- 'let' command in vim are the same as 'vim.g'

vim.g.mapleader = ' '

vim.g.ttyfast = true
vim.g.noswapfile = true

vim.o.termguicolors = true
vim.opt.clipboard:append { 'unnamedplus' }

-- Set matching pairs of characters and highlight matching brackets
vim.opt.matchpairs:append { '<:>,「:」,『:』,【:】,“:”,‘:’,《:》'}

-- vim.updatetime = 40
vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd([[let g:test#python#runner = "nose"]])

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.signcolumn = 'yes'

vim.opt.swapfile = false

-- vim.opt.backupdir =~/.cache/vim " Directory to store backup files.

vim.opt.timeoutlen=500

 -- For CursorHold events
vim.opt.updatetime=500 

-- let test#strategy = "dispatch"
-- vim.g.test.strategy = 'dispatch'

vim.opt.spelllang=en
vim.opt.spellsuggest="best,9"

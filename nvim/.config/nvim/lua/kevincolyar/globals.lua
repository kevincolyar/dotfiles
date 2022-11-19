-- 'set' command in vim are the same as 'vim.opt'
-- 'let' command in vim are the same as 'vim.g'

vim.g.mapleader = ' '

vim.g.ttyfast = true
vim.g.noswapfile = true

vim.opt.termguicolors = true
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

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.scrolloff = 8

vim.opt.signcolumn = 'yes'

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.timeoutlen=500

 -- For CursorHold events
vim.opt.updatetime=500 

-- let test#strategy = "dispatch"
-- vim.g.test.strategy = 'dispatch'
vim.cmd([[let g:test#strategy = "harpoon"]])

vim.cmd([[set spell!]])
vim.g.spelllang=en_us
vim.g.spellsuggest="best,9"

-- Ignore case when completing/searchin in command line, etc
vim.opt.ignorecase = true
vim.opt.wildignorecase = true

vim.opt.list = true
-- vim.opt.listchars:append "eol:↴"

-- Hide Status Line
-- vim.opt.laststatus = 0
-- vim.opt.ruler = false

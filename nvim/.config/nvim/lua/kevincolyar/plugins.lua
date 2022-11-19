vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- UI
  use { 'rcarriga/nvim-notify' }
  use { 'gelguy/wilder.nvim' }
  use { 'kyazdani42/nvim-web-devicons' }
  -- use { "catppuccin/nvim", as = "catppuccin" }
  use { 'feline-nvim/feline.nvim' }
  -- use { 'shaunsingh/nord.nvim'}
  use { 'EdenEast/nightfox.nvim' }
  use { 'yamatsum/nvim-cursorline'}
  use { 'lukas-reineke/indent-blankline.nvim'}
  use { 'xiyaowong/nvim-transparent' }

  -- File navigation
  use { 
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Dev
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'tpope/vim-commentary' }
  use { 'mfussenegger/nvim-lint' }
  use { 'vim-test/vim-test' }

  -- LSP
  -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
  use { "neovim/nvim-lspconfig" }
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "jose-elias-alvarez/null-ls.nvim" }

  -- auto-completion engine
  use { "onsails/lspkind-nvim" }
  use { "hrsh7th/nvim-cmp" }

  -- nvim-cmp completion sources
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-buffer" }
  -- use { "hrsh7th/cmp-omni" }
  use { 'L3MON4D3/LuaSnip' } -- Snippets plugin
  use { 'saadparwaiz1/cmp_luasnip' }  -- Snippets source for nvim-cmp
  use { 'rafamadriz/friendly-snippets' }

  -- Other LSP
  use { 'simrat39/rust-tools.nvim' }
  use { 'mfussenegger/nvim-dap' }
  use { 'j-hui/fidget.nvim' }

  -- Snippets
 
  -- Git
  use 'tpope/vim-fugitive'
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use { "lewis6991/gitsigns.nvim" }
  -- use { 'f-person/git-blame.nvim' }
  
  -- Themes
  use { 'folke/tokyonight.nvim' }
  use { 'ellisonleao/gruvbox.nvim' }
  use { 'sainnhe/sonokai' }

  -- Org
  use { 'nvim-orgmode/orgmode' }
  use {'akinsho/org-bullets.nvim' }
  
  -- Testing
  use { 'ThePrimeagen/harpoon' }
  use { 'tpope/vim-dispatch' }

  -- Misc
  use { 'jamessan/vim-gnupg' }
  use { 'jghauser/follow-md-links.nvim' }
  use { 'folke/which-key.nvim' }
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, 
    ft = { "markdown" }
  })

end)



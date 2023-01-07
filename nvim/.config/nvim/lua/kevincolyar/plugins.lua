vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- UI
  -- use { 'rcarriga/nvim-notify' }
  use { 'gelguy/wilder.nvim' }
  use { 'kyazdani42/nvim-web-devicons' }
  -- use { "catppuccin/nvim", as = "catppuccin" }
  use { 'feline-nvim/feline.nvim' }
  -- use { 'shaunsingh/nord.nvim'}
  use { 'EdenEast/nightfox.nvim' }
  use { 'yamatsum/nvim-cursorline'}
  -- use { 'lukas-reineke/indent-blankline.nvim'} -- Show indent lines
  use { 'xiyaowong/nvim-transparent' }
  use { }

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
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      local saga = require("lspsaga")

      saga.init_lsp_saga({
        -- your configuration
      })
    end,
  })

  -- Languages
  use "tpope/vim-rails"
  use "vim-ruby/vim-ruby"

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



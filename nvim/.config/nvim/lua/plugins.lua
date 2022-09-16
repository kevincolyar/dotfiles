vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- UI
  use { 'rcarriga/nvim-notify' }
  use { 'gelguy/wilder.nvim', config = [[require('config/wilder')]] }
  use { 'kyazdani42/nvim-web-devicons' }
  -- use {
	  -- 'nvim-lualine/lualine.nvim',
	  -- requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  --     config = [[require('config.lualine') ]]
  -- }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'feline-nvim/feline.nvim' , config = [[require('config.feline')]], after="catppuccin" }
  use { 'yamatsum/nvim-cursorline', config = [[require('config.nvim-cursorline')]] }

  -- File navigation
  use { 
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    config = [[require('config.telescope')]],
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Dev
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'tpope/vim-commentary' }
  use { 'mfussenegger/nvim-lint' }
  use { 'vim-test/vim-test' }

  -- LSP
  -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
  use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.nvim-lspconfig')]] }
  use { "williamboman/mason.nvim", config = [[require('config.mason')]] }
  use { "williamboman/mason-lspconfig.nvim" }

  -- auto-completion engine
  use { "onsails/lspkind-nvim", event = "VimEnter" }
  use { "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]] }

  -- nvim-cmp completion sources
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  -- use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
  use { 'L3MON4D3/LuaSnip' } -- Snippets plugin
  -- use { 'saadparwaiz1/cmp_luasnip' }  -- Snippets source for nvim-cmp
  use { 'rafamadriz/friendly-snippets' }
  use { 'simrat39/rust-tools.nvim', config=[[require('config.rust-tools')]], after="nvim-lspconfig"}
  use 'mfussenegger/nvim-dap'

  -- Snippets
 
  -- Git
  use 'tpope/vim-fugitive'
  use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }
  -- use { 'f-person/git-blame.nvim' }
  
  -- Themes
  use { 'folke/tokyonight.nvim' }
  use { 'ellisonleao/gruvbox.nvim' }
  use { 'sainnhe/sonokai' }

  -- Org
  use { 'nvim-orgmode/orgmode', config = [[require('config.orgmode')]] }
  use {'akinsho/org-bullets.nvim', config = function()
      require('org-bullets').setup()
  end}
  --
  -- Testing
  use { 'ThePrimeagen/harpoon' }
  use { 'tpope/vim-dispatch' }

  -- Misc
  use { 'jamessan/vim-gnupg' }
  use { 'jghauser/follow-md-links.nvim' }
  use { 'folke/which-key.nvim', config = [[require('config.which-key')]] }
end)



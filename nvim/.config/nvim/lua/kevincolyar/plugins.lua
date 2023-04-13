vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- UI
  use { 'kyazdani42/nvim-web-devicons' }
  -- use { 'feline-nvim/feline.nvim' }
  -- use { 'EdenEast/nightfox.nvim' }
  -- use { 'sainnhe/everforest' }
  -- use { 'rebelot/kanagawa.nvim' }
  -- use { 'kvrohit/rasmus.nvim' }
  use {'nyoom-engineering/oxocarbon.nvim'}

  use {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require('wilder')

      wilder.setup({
        modes = {':'},
        next_key = '<C-j>',
        previous_key = '<C-k>',
      })

      wilder.set_option('renderer', wilder.popupmenu_renderer({
        highlighter = wilder.basic_highlighter(),
        left = {' ', wilder.popupmenu_devicons()},
        right = {' ', wilder.popupmenu_scrollbar()},
        -- pumblend = 30,
      }))
    end
  }

  use {
    'freddiehaddad/feline.nvim',
    config = function()
      require('feline').setup()
      require('feline').winbar.setup()
    end
  }

  -- use {
  --   'yamatsum/nvim-cursorline',
  --   config = function()
  --     require('nvim-cursorline').setup {
  --       cursorline = {
  --         enable = true,
  --         timeout = 300,
  --         number = false,
  --       },
  --       cursorword = {
  --         enable = true,
  --         min_length = 3,
  --         hl = { underline = false },
  --       }
  --     }
  --   end
  -- }
  use {
    'xiyaowong/nvim-transparent',
    config = function()
      require("transparent").setup({
        extra_groups = {
          'all'
        }
      })
    end
  }

  -- File navigation
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local actions = require('telescope.actions')

      require('telescope').setup{
        defaults = {
          layout_strategy = "vertical",
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous
            }
          }
        },
      }
    end
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
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function()
      local lsp = require('lsp-zero')

      lsp.preset('recommended')
      lsp.ensure_installed({
        'tsserver',
        'eslint',
        'rust_analyzer'
      })

      lsp.nvim_workspace()
      lsp.setup()

      vim.diagnostic.config({
        -- virtual_text = true
      })
    end
  }

  use({
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup({})
    end,
    requires = {
      {"nvim-tree/nvim-web-devicons"},
      --Please make sure you install markdown and markdown_inline parser
      {"nvim-treesitter/nvim-treesitter"}
    }
  })

  -- Languages
  use "tpope/vim-rails"
  use "vim-ruby/vim-ruby"
  use {
    'saecki/crates.nvim',
    tag = 'v0.3.0',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  }

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
  use { 'mfussenegger/nvim-dap' }
  use {
    'simrat39/rust-tools.nvim',
    config = function()
      require("rust-tools").setup({
        tools = { 
          inlay_hints = {
            auto = true
          }
        }
      })
    end
  }
  use({
    'j-hui/fidget.nvim',
    setup = function()
      window = {
        blend = 0
      }
    end
  })

  -- Git
  use { 'tpope/vim-fugitive' }
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
          changedelete = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        }
      })
    end
  }
  use {
    'rhysd/git-messenger.vim',
    setup = function()
      vim.keymap.set('n', '<leader>gm', "<cmd>:GitMessenger<cr>")
    end
  }

  -- Testing
  use { 'ThePrimeagen/harpoon' }
  use { 'tpope/vim-dispatch' }

  -- Misc
  use { 'jghauser/follow-md-links.nvim' }
  use {
    'folke/which-key.nvim',
    config = function()
      require("which-key").register({
        b = { name = "Buffers" },
        c = { name = "Code" },
        f = { name = "Files" },
        g = { name = "Git" },
        p = { name = "Packer" },
        s = { name = "Search" },
        t = { name = "Test" },
      }, { prefix = "<leader>" })
    end
  }
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }
  })

end)



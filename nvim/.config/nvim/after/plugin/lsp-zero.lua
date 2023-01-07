local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
  'rust_analyzer'
})

lsp.nvim_workspace()
lsp.setup()

vim.diagnostic.config({
  -- virtual_text = true
})

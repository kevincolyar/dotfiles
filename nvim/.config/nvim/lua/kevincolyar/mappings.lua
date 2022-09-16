
-- Misc
vim.keymap.set('i', 'fd', "<esc>")
vim.keymap.set('n', '<leader>k',  "<cmd>lua require('telescope.builtin').keymaps()<cr>")     -- Key Maps

-- Telescope
vim.keymap.set('n', '<leader>*', "<cmd>lua require('telescope.builtin').grep_string()<cr>")  -- Search Current String
vim.keymap.set('x', '<leader>*', "<cmd>lua require('telescope.builtin').grep_string()<cr>")  -- Search Current String
vim.keymap.set('n', '<leader>/', "<cmd>lua require('telescope.builtin').live_grep()<cr>")    -- Live Grep
vim.keymap.set('n', '<leader>sl',"<cmd>lua require('telescope.builtin').resume()<cr>")       -- Resume Search
vim.keymap.set('n', '<leader>h',  "<cmd>lua require('telescope.builtin').help_tags()<cr>")       -- Resume Search

-- File Navigation
vim.keymap.set('n', '<leader><tab>', "<C-6>") -- Previous Buffer
vim.keymap.set('n', '<leader>ff',    "<cmd>lua require('telescope.builtin').find_files()<cr>")
vim.keymap.set('n', '<leader>fs',    "<cmd>:w<cr>")
vim.keymap.set('n', '<leader>pf', "<cmd>lua require('telescope.builtin').git_files()<cr>")

--  Packer
vim.keymap.set('n', '<leader>pi', "<cmd>:PackerInstall<cr>")
vim.keymap.set('n', '<leader>ps', "<cmd>:PackerSync<cr>")

-- Testing
vim.keymap.set('n', '<leader>tt', "<cmd>:TestNearest<cr>")
vim.keymap.set('n', '<leader>ta', "<cmd>:TestSuite<cr>")

-- Git
vim.keymap.set('n', '<leader>gb', "<cmd>:Git blame<cr>")
vim.keymap.set('n', '<leader>gs', "<cmd>:Git status<cr>")
vim.keymap.set('n', '<leader>gg', "<cmd>:Neogit<cr>")

-- LSP
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d',       vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d',       vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local ret = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function ret.lsp_on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd',        vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K',         vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>',     vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D',  vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr',        vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f',  vim.lsp.buf.formatting, bufopts)
end

return ret

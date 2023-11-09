
-- Misc
-- vim.keymap.set('i', 'fd', "<esc>")
vim.keymap.set('n', '<leader>:',  "<cmd>Telescope commands<cr>")     -- Key Maps
vim.keymap.set('n', '<leader>;',  "<cmd>Telescope command_history<cr>")     -- Key Maps
vim.keymap.set('n', '<leader>k',  "<cmd>Telescope keymaps<cr>")     -- Key Maps

-- Telescope
vim.keymap.set('n', '<leader>*',  "<cmd>Telescope grep_string<cr>")  -- Search Current String
vim.keymap.set('n', '<leader>/',  "<cmd>Telescope live_grep<cr>")    -- Live Grep
vim.keymap.set('n', '<leader>sl', "<cmd>Telescope resume<cr>")       -- Resume Search
vim.keymap.set('n', '<leader>h',  "<cmd>Telescope help_tags<cr>")   -- Resume Search

-- File Navigation
vim.keymap.set('n', '<leader><tab>', "<C-6>")                            -- Previous Buffer
vim.keymap.set('n', '<leader>ff', "<cmd>Telescope find_files<cr>")
vim.keymap.set('n', '<leader>bb', "<cmd>Telescope buffers<cr>")
vim.keymap.set('n', '<leader>fs', "<cmd>:w<cr>")
vim.keymap.set('n', '<leader>pf', "<cmd>Telescope git_files<cr>", {desc='Project Files'})

--  Packer
vim.keymap.set('n', '<leader>pi', "<cmd>:PackerInstall<cr>")
vim.keymap.set('n', '<leader>ps', "<cmd>:PackerSync<cr>")

-- Testing
vim.keymap.set('n', ',tt', "<cmd>:TestNearest<cr>")
vim.keymap.set('n', ',ta', "<cmd>:TestSuite<cr>")
vim.keymap.set('n', ',tl', "<cmd>:TestLast<cr>")

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
vim.keymap.set('n', '<space>ce', vim.diagnostic.setloclist, opts)

-- vim.keymap.set('n', 'ca',       vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<leader>cf', "<cmd>Lspsaga lsp_finder<CR>", opts)
vim.keymap.set('n', '<leader>ca', "<cmd>Lspsaga code_action<CR>", opts)
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>so", "<cmd>Lspsaga outline<CR>", opts)
-- vim.keymap.set("n", "gd",         "<cmd>Lspsaga peek_definition<CR>", opts)
-- vim.keymap.set("n", "gd",         "<cmd>Lspsaga goto_definition<CR>", opts)
vim.keymap.set("n", "gd",         vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr',         "<cmd>:Telescope lsp_references<cr>")
vim.keymap.set("n", "gR",         "<cmd>Lspsaga rename<CR>", opts)
vim.keymap.set("n", "gP",         "<cmd>Lspsaga rename ++project<CR>", opts)
vim.keymap.set("n", "K",          "<cmd>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "<leader>D",  vim.lsp.buf.type_definition, opts)
vim.keymap.set("n", "<leader>ds",  require('telescope.builtin').lsp_document_symbols, opts)
vim.keymap.set("n", "<leader>ws",  require('telescope.builtin').lsp_dynamic_workspace_symbols, opts)

vim.keymap.set('n', 'z=', "<cmd>Telescope spell_suggest<cr>", {desc='Suggest Spelling'})

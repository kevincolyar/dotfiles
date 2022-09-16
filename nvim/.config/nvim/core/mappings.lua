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

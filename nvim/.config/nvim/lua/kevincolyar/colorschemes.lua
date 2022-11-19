require('tokyonight').setup({
	transparent = true
})

-- TODO: Why can't this be in plugin/after/catppuccin.lua?
-- require("catppuccin").setup({
-- 	transparent_background = true,
--   integrations = {
--     telescope = true
--   }
-- })

vim.g.sonokai_transparent_background = 2
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_spell_foreground = "colored"
vim.g.sonokai_better_performance = 1

-- vim.cmd [[colorscheme tokyonight]]
-- vim.cmd [[colorscheme sonokai]]
-- vim.cmd [[colorscheme catppuccin]]
vim.cmd [[colorscheme nordfox]]

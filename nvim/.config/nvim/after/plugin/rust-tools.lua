local rt = require("rust-tools")
-- local mappings = require('kevincolyar.mappings')

rt.setup({
  server = {
    -- on_attach = mappings.lsp_on_attach
    -- on_attach = function(_, bufnr)
    --   -- Hover actions
    --   vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --   -- Code action groups
    --   vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    -- end,
  },
  inlay_hints = true,
  tools = {
    inlay_hints = {
      -- auto = true,
      -- only_current_line = true
    }
  }
})

local rt = require("rust-tools")
local mappings = require('mappings')

rt.setup({
  server = {
    on_attach = mappings.lsp_on_attach
    -- on_attach = function(_, bufnr)
    --   -- Hover actions
    --   vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --   -- Code action groups
    --   vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    -- end,
  },
  tools = {
    inlay_hints = {
      -- auto = false,
      only_current_line = true
    }
  }
})

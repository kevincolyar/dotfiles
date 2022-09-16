require("wilder").setup({modes = {':', '/', '?'}})

wilder = require('wilder')

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = wilder.basic_highlighter(),
  left = {' ', wilder.popupmenu_devicons()},
  right = {' ', wilder.popupmenu_scrollbar()},
  -- pumblend = 30,
}))

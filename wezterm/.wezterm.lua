local wezterm = require 'wezterm'

return {
   check_for_updates = false,
   enable_tab_bar = false,
   window_decorations = "RESIZE",
   color_scheme = 'oxocarbon',
   -- color_scheme = 'DoomOne',
   -- color_scheme = 'tokyonight',
   -- color_scheme = "Catppuccin Mocha",
   -- color_scheme = 'Dracula (Gogh)',
   -- color_scheme = "Gigavolt (base16)",
   -- color_scheme = "Later This Evening",
   font = wezterm.font('Fisa Code'),
   -- font = wezterm.font('FuraMono Nerd Font'),
   -- font = wezterm.font('SauceCode Pro Nerd Font Regular'),
   -- font = wezterm.font('Fisa Code', { weight = 'Thin' }),
   font_size = 16,
   window_background_opacity = 0.88,
   macos_window_background_blur = 40,
   harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

   -- Disable Italic
   font_rules = {
     {
       italic = true,
       font = wezterm.font {
         family = "Fisa Code",
         italic = false
       },
     },
   }
}

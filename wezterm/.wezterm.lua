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
   font = wezterm.font('FiraCode Nerd Font'),
   -- font = wezterm.font('FuraMono Nerd Font'),
   -- font = wezterm.font('SauceCode Pro Nerd Font Regular'),
   -- font = wezterm.font('Fisa Code', { weight = 'Thin' }),
   font_size = 14,
   adjust_window_size_when_changing_font_size = false,
   -- window_background_opacity = 0.80,
   -- macos_window_background_blur = 20,
   harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

   -- Disable Italic
   font_rules = {
     {
       italic = true,
       font = wezterm.font {
         family = "FiraCode Nerd Font",
         italic = false
       },
     },
   },
   keys = {
      {
         key = 'f',
         mods = 'SHIFT|CTRL',
         action = wezterm.action.ToggleFullScreen,
      },
   }
}

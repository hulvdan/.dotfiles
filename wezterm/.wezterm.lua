local wezterm = require("wezterm")
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config.color_scheme = "Gruvbox dark, hard (base16)"
config.font = wezterm.font({
  family = "For use only at ilovetypography.com",
  weight = "DemiBold",
  style = "Normal",
})
config.font_rules = {
  { intensity = "Half", italic = true, font = config.font },
  { intensity = "Half", italic = false, font = config.font },
  { intensity = "Bold", italic = true, font = config.font },
  { intensity = "Bold", italic = false, font = config.font },
  { intensity = "Normal", italic = true, font = config.font },
  { intensity = "Normal", italic = false, font = config.font },
}

config.enable_csi_u_key_encoding = true
config.allow_win32_input_mode = false
config.enable_kitty_keyboard = false

config.disable_default_key_bindings = true
config.window_decorations = "RESIZE"

config.font_size = 13

config.keys = {
  { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
}

config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config

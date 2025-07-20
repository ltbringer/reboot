local wezterm = require 'wezterm'

local config = wezterm.config_builder()


config.initial_cols = 120
config.initial_rows = 28
config.font_size = 22
config.color_scheme = 'N0tch2k'
config.font = wezterm.font('FantasqueSansM Nerd Font')

return config

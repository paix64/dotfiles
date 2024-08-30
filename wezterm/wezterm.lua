local wezterm = require("wezterm")
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.initial_cols = 80
config.initial_rows = 20

config.font_size = 16.0
config.font = wezterm.font("Jetbrains Mono Nerd Font", { weight = "Bold" })
config.color_scheme = "Gruvbox dark, hard (base16)"
config.hide_tab_bar_if_only_one_tab = true
config.selection_word_boundary = "\t\n{}[]()\"'`-/.,;:❯ "

config.colors = {
	-- foreground = "#00FF00",
	-- background = "black",

	-- cursor_bg = "#FFFFFF",
	-- cursor_fg = "black",

	-- selection_fg = "black",
	--selection_bg = "#00ff00",

	--split = "#444444",
}

config.window_frame = {
	active_titlebar_bg = "rgba(0 0 0 0)",
}

config.window_background_opacity = 0.60

return config

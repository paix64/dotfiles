local wezterm = require("wezterm")

local config = {
	initial_cols = 80,
	initial_rows = 20,

	window_padding = {
		top = 10,
		left = 10,
		right = 10,
		bottom = 0,
	},

	enable_tab_bar = false,

	window_background_opacity = 0.60,

	font_size = 16.0,

	font = wezterm.font("Jetbrains Mono Nerd Font", { weight = "Bold" }),
	color_scheme = "Gruvbox dark, hard (base16)",
	selection_word_boundary = "\t\n{}[]()\"'`-/.,;:❯ ",
	line_height = 0.90,
	colors = {
		-- foreground = "#00FF00",
		-- background = "black",

		-- cursor_bg = "#FFFFFF",
		-- cursor_fg = "black",

		-- selection_fg = "black",
		--selection_bg = "#00ff00",

		--split = "#444444",
	},
}
return config

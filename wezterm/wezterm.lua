local wezterm = require("wezterm")
local act = wezterm.action
local bar = require("bar")

local config = {
	initial_cols = 80,
	initial_rows = 20,

	window_padding = {
		top = 10,
		left = 10,
		right = 10,
		bottom = 0,
	},

	window_background_opacity = 0.60,

	font_size = 16.0,
	font = wezterm.font("Jetbrains Mono Nerd Font", { weight = "Bold" }),

	color_scheme = "Gruvbox dark, hard (base16)",
	selection_word_boundary = "\t\n{}[]()\"'`-/.,;:❯ ",
	line_height = 0.90,
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	colors = {
		-- foreground = "#00FF00",
		-- background = "black",

		-- cursor_bg = "#FFFFFF",
		-- cursor_fg = "black",

		-- selection_fg = "black",
		--selection_bg = "#00ff00",

		--split = "#444444",
	},
	keys = {
		{ key = "F1", mods = "", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
		{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
		{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
		{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
		{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	},
}
bar.apply_to_config(config, {
	position = "top",
	enabled_modules = {

		workspace = false,
		pane = false,
		clock = false,
		username = false,
		hostname = false,
	},
})
return config

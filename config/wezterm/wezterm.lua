local wezterm = require("wezterm")
local act = wezterm.action
local bar = require("bar")

local config = {
	initial_cols = 70,
	initial_rows = 20,

	window_padding = {
		top = "0.5cell",
		left = "1cell",
		right = "1cell",
		bottom = "0.5cell",
	},

	window_background_opacity = 0.60,

	font_size = 16.0,
	font = wezterm.font("Jetbrains Mono Nerd Font", { weight = "Bold" }),
	default_cursor_style = "BlinkingBar",
	cursor_blink_rate = 500,
	cursor_thickness = "2px",
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	color_scheme = "Gruvbox dark, hard (base16)",
	selection_word_boundary = "\t\n{}[]()\"'`-/.,;: ",
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
		{ key = "F1", mods = "",     action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "w",  mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
		{ key = "1",  mods = "ALT",  action = act.ActivateTab(0) },
		{ key = "2",  mods = "ALT",  action = act.ActivateTab(1) },
		{ key = "3",  mods = "ALT",  action = act.ActivateTab(2) },
		{ key = "4",  mods = "ALT",  action = act.ActivateTab(3) },
		{ key = "5",  mods = "ALT",  action = act.ActivateTab(4) },

		{ key = "p",  mods = "CTRL", action = act.EmitEvent("padding-off") },
		{ key = "o",  mods = "CTRL", action = act.EmitEvent("toggle-opacity") },
	},
}

wezterm.on("padding-off", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_padding then
		overrides.window_padding = {
			top = "0",
			right = "0",
			bottom = "0",
			left = "0",
		}
	else
		overrides.window_padding = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

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

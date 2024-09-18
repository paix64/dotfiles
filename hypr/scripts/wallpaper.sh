#!/usr/bin/env bash

export SWWW_TRANSITION_FPS=165
export SWWW_TRANSITION_DURATION=2.0
export SWWW_TRANSITION=any

wallpaper_path=$HOME/Pictures/Wallpapers

if [[ $1 == "-r" ]]; then
    wallpapers=($(find "$wallpaper_path" -type f))
    random_wallpaper=${wallpapers[RANDOM % ${#wallpapers[@]}]}
    swww img "$random_wallpaper"
else
    selection="$(ls $wallpaper_path | rofi -dmenu || pkill rofi)"
    while [[ ! -f $wallpaper_path/$selection ]]; do
        wallpaper_path="$wallpaper_path/$selection"
        selection="$(ls $wallpaper_path | rofi -dmenu || pkill rofi)"
    done
    swww img $wallpaper_path/$selection
fi

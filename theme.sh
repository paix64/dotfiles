#!/bin/bash

color_scheme="prefer-dark"
gtk_theme="adw-gtk3-dark"
icon_theme="Papirus-Dark"
cursor_theme="Bibata-Modern-Ice"

# initiate GTK dark mode and apply icon and cursor theme
gsettings set org.gnome.desktop.interface color-scheme $color_scheme > /dev/null 2>&1 &
gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme > /dev/null 2>&1 &
gsettings set org.gnome.desktop.interface icon-theme $icon_theme > /dev/null 2>&1 &
gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme > /dev/null 2>&1 &
gsettings set org.gnome.desktop.interface cursor-size 24 > /dev/null 2>&1 & 
gsettings set org.gnome.desktop.interface font-name "Ubuntu Nerd Font Bold 12" > /dev/null 2>&1 &

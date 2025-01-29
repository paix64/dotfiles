#!/usr/bin/env bash
  
  echo ":: Installing packages"
  sleep .4
  paru -S --needed gnome-themes-extra gtk-engine-murrine sassc \
        bibata-cursor-theme-bin papirus-icon-theme ttf-google-sans
  
  echo ":: Installing Graphite theme"
  sleep .4
  git clone https://github.com/vinceliuice/Graphite-gtk-theme.git \
  /tmp/Graphite
  sudo sh /tmp/Graphite/install.sh --gdm --color dark --tweaks normal darker -l
  
  color_scheme="prefer-dark"
  gtk_theme="Graphite-Dark"
  icon_theme="Papirus-Dark"
  cursor_theme="Bibata-Modern-Ice"
  font_name="Google Sans Medium 12"
  cursor_size=32
  
  echo ":: Applying themes"
  sleep .4
  gsettings set org.gnome.desktop.interface color-scheme $color_scheme
  gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme
  gsettings set org.gnome.desktop.interface icon-theme $icon_theme
  gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme
  gsettings set org.gnome.desktop.interface cursor-size $cursor_size
  gsettings set org.gnome.desktop.interface font-name $font_name
  
  echo ":: Applying settings"
  sleep .4
  gsettings set org.gtk.Settings.FileChooser show-hidden true
  gsettings set org.gtk.Settings.FileChooser window-size '(1100,700)'
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 5
  gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
  gsettings set org.gnome.desktop.wm.preferences focus-mode 'mouse'

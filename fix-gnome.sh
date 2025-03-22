#!/usr/bin/env bash
  echo ":: Applying settings"
  sleep .4

  gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
  gsettings set org.gnome.desktop.interface cursor-size 32
  gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans Medium 12'
  gsettings set org.gnome.desktop.interface document-font-name 'Adwaita Sans Medium 12'
  gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Semi-Bold 10'

  gsettings set org.gtk.Settings.FileChooser show-hidden true
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
  gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
  gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
  gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,close'

  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>Q']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super>1']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super>2']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super>3']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super>4']"
  
  gsettings set org.gnome.desktop.interface accent-color 'red'
  gsettings set org.gnome.desktop.interface clock-format '24h'
  gsettings set org.gnome.desktop.interface clock-show-weekday true
  gsettings set org.gnome.desktop.interface show-battery-percentage true

  gsettings set org.gnome.desktop.peripherals.keyboard delay 150
  gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 50
  gsettings set org.gnome.desktop.peripherals.mouse speed 0.5
  gsettings set org.gnome.desktop.peripherals.touchpad speed 0.62

  gsettings set org.gnome.desktop.privacy remove-old-temp-files true
  gsettings set org.gnome.desktop.wm.preferences audible-bell false
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.mutter dynamic-workspaces false

  gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
  gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates (35.0, 35.0)
  gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3200

  gsettings set org.gnome.settings-daemon.plugins.media-keys home ['<Super>e']
  gsettings set org.gnome.settings-daemon.plugins.media-keys www ['<Super>w']
  gsettings set org.gnome.shell.keybindings show-screenshot-ui ['<Shift><Super>s']

  gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 300
  gsettings set org.gnome.settings-daemon.plugins.power idle-brightness 10

  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'terminal'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'ghostty'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'system-monitor'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'missioncenter'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Escape'
  

#!/bin/bash

ask_continue() {
  local message=$1
  local exit_on_no=${2:-true}
  if gum confirm "$message"; then
    return 0
  else
    echo ":: Skipping $message."
    if $exit_on_no; then
      echo ":: Exiting script."
      exit 0
    else
      return 1
    fi
  fi
}

setup_yay() {
  if command -v yay &>/dev/null; then
    echo ":: Yay is installed"
    sleep 1
  else
    echo ":: Yay is not installed!"
    sleep 1
    install_yay
  fi
}

setup_colors() {
  echo ":: Setting colors"
  ln -s -f $HOME/dotfiles/wal $HOME/.config/wal
  python -O $HOME/dotfiles/material-colors/generate.py --color "#0000FF"
}

copy_files() {
  echo ":: Copying files"
  sh $HOME/dotfiles/setup/copy.sh
}

remove_gtk_buttons() {
  echo ":: Remove window close and minimize buttons in GTK"
  gsettings set org.gnome.desktop.wm.preferences button-layout ':'
}

main() {
  if [[ $1 == "packages" ]]; then
    setup_yay
    install_packages
    exit 0
  fi

  setup_yay

  if ! command -v gum &>/dev/null; then
    echo ":: gum not installed"
    sudo pacman -S gum
  fi

  ask_continue "Proceed with installing packages?" false && install_packages
  ask_continue "Proceed with setting up sensors?" false && setup_sensors
  ask_continue "Proceed with checking config folders?*" && check_config_folders
  ask_continue "Proceed with installing Tela Nord icons?" false && install_tela_nord_icons
  ask_continue "Proceed with setting up colors?*" && setup_colors
  ask_continue "Proceed with setting up SDDM?" false && setup_sddm
  ask_continue "Proceed with copying files?*" && copy_files
  ask_continue "Proceed with creating links?*" && create_links
  ask_continue "Proceed with removing GTK buttons?" false && remove_gtk_buttons
  ask_continue "Proceed with setting up services?*" && setup_services
  ask_continue "Proceed with updating user directories?*" && update_user_dirs
  ask_continue "Proceed with miscellaneous tasks?*" && misc_tasks

  echo "Please restart your PC"
}

main "$@"

#!/bin/bash

DATE=$(date +%F_%H:%M)

RED="\u001b[31m"
GREEN="\u001b[32m"
YELLOW="\u001b[33m"
BLUE="\u001b[34m"
MAGENTA="\u001b[35m"
CYAN="\u001b[36m"
ESC="\u001b[0m"

if ! grep -q "arch" /etc/os-release; then
  echo -e "$BLUE::$ESC This script is designed to run on$BLUE Arch Linux. $ESC"
  exit 1
fi

if [ ! -d "$HOME/Repositories/dotfiles" ]; then
  echo -e "$BLUE::$ESC The directory $YELLOW$HOME/Repositories/dotfiles$ESC$RED does not exist. $ESC"
  exit 1
fi

install_yay() {
  if command -v yay &>/dev/null; then
    echo ":: Yay is installed"
  else
    echo ":: Installing yay..."
  fi

  sleep .4

  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm base-devel git
  git clone --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm --needed
}

install_packages() {
  echo ":: Installing packages"
  sleep .4

  yay -Syu --noconfirm
  yay -S --needed - <packages.conf
}

setup_sensors() {
  echo ":: Setting up sensors"
  sleep .4

  sudo sensors-detect --auto >/dev/null
}

check_config_folders() {
  echo ":: Checking for existing folders"
  sleep .4

  local CONFIG_FOLDER="$HOME/.config"
  local BACKUP_FOLDER="$HOME/.backup"
  local DATETIME=$(date '+%Y-%m-%d_%H-%M-%S')
  local EXISTING="NO"

  mkdir -p "$BACKUP_FOLDER/$DATETIME/"

  for dir in $(ls ./config); do
    if [ -d "$CONFIG_FOLDER/$dir" ]; then
      echo ":: Attention: directory $dir already exists in .config"
      mv "$CONFIG_FOLDER/$dir" "$BACKUP_FOLDER/$DATETIME/"
      EXISTING="YES"
    fi
  done

  if [[ $EXISTING == "YES" ]]; then
    echo ":: Old config folder(s) backed up at $BACKUP_FOLDER/$DATETIME"
  fi
}

link_config_folders() {
  check_config_folders

  echo ":: Creating links"
  sleep .4

  local CONFIG_FOLDER="$HOME/.config"
  local DOTFILES_FOLDER="$HOME/Repositories/dotfiles/config"
  local LOCAL_SHARE_FOLDER="$HOME/.local/share"

  for dir in $(ls ./config); do
    if [ -d "./config/$dir" ]; then
      if [[ $dir == "localshare"* ]]; then
        ln -s "$DOTFILES_FOLDER/localshare/zoxide" "$LOCAL_SHARE_FOLDER/"
      else
        ln -s "$DOTFILES_FOLDER/$dir" "$CONFIG_FOLDER/"
      fi
    fi
  done
}

rate_mirrors() {
  echo ":: Rating mirrors"
  sleep .4

  rate-mirrors --save /tmp/mirrorlist arch
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo mv /tmp/mirrorlist /etc/pacman.d/mirrorlist
}

setup_user_dirs() {
  echo ":: Creating user directories"
  sleep .4

  xdg-user-dirs-update
}

setup_virtual_network(){
  echo ":: Setting up virtual network"
  sleep .4

  sudo systemctl enable --now libvirtd.socket
  sudo virsh net-autostart default
}

setup_fish() {
  echo ":: Setting up fish"
  sleep .4

  chsh -s $(which fish)
}

setup_power_key() {
  echo ":: Setting up power key"
  sleep .4

  sudo cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak
  sudo sed -i 's/^#HandlePowerKey=poweroff/HandlePowerKey=ignore/' /etc/systemd/logind.conf
}

setup_firewall() {
  echo ":: Setting up firewall"
  sleep .4

  systemctl enable --now ufw
  sudo ufw enable
  sudo ufw default deny
  sudo ufw allow from 192.168.0.0/24
  sudo ufw allow from 192.168.122.0/24  # virtual network
  sudo ufw deny ssh
}

setup_bun() {
  echo ":: Setting up bun"
  sleep .4

  curl -fsSL https://bun.sh/install | bash
  sudo ln -s $HOME/.bun/bin/bun /usr/local/bin/bun
  sudo ln -s $HOME/.bun/bin/bunx /usr/local/bin/bunx
}

setup_electron() {
  echo ":: Setting up electron"
  echo -e "--enable-features=UseOzonePlatform\n--ozone-platform=wayland\n--disable-gpu-compositing" >~/.config/electron-flags.conf
  ln -s ~/.config/electron-flags.conf ~/.config/code-flags.conf
}

setup_timeshift() {
  echo ":: Setting up timeshift"
  sleep .4

  systemctl enable --now cronie

  local ROOT=$(findmnt -no UUID /)

  sudo tee /etc/timeshift/timeshift.json >/dev/null <<EOF
{
    "backup_device_uuid" : "$ROOT",
    "parent_device_uuid" : "",
    "do_first_run" : "false",
    "btrfs_mode" : "false",
    "include_btrfs_home_for_backup" : "false",
    "include_btrfs_home_for_restore" : "false",
    "stop_cron_emails" : "true",
    "schedule_monthly" : "false",
    "schedule_weekly" : "false",
    "schedule_daily" : "true",
    "schedule_hourly" : "false",
    "schedule_boot" : "true",
    "count_monthly" : "0",
    "count_weekly" : "0",
    "count_daily" : "3",
    "count_hourly" : "0",
    "count_boot" : "2",
    "snapshot_size" : "",
    "snapshot_count" : "",
    "date_format" : "%Y-%m-%d %H:%M:%S",
    "exclude" : [
      "+ /home/$USER/**",
      "- /root/**",
      "- /home$USER/.var/**"
    ],
    "exclude-apps" : []
}
EOF
}

setup_rust() {
  echo ":: Setting up rust"
  sleep .4

  rustup default stable
}

install_theme() {
  echo ":: Installing themes"
  sleep .4

  git clone https://github.com/vinceliuice/Graphite-gtk-theme.git \
  /tmp/Graphite
  /tmp/Graphite/install.sh -c dark --tweaks normal black -l
  
  color_scheme="prefer-dark"
  gtk_theme="Graphite-Dark"
  icon_theme="Papirus-Dark"
  cursor_theme="Bibata-Modern-Ice"
  cursor_size=32
  
  gsettings set org.gnome.desktop.interface color-scheme $color_scheme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface icon-theme $icon_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface cursor-size $cursor_size
  gsettings set org.gnome.desktop.interface font-name "Google Sans Medium 14" >/dev/null 2>&1 &
}

setup_nemo() {
  echo ":: Setting up nemo"
  sleep .4

  gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty
}

setup_asusctl() {
  echo ":: Setting up asusctl"
  sleep .4

  asusctl -c 80
}

setup_pacman() {
  echo ":: Setting up pacman"
  sleep .4

  local pacman_config_file="/etc/pacman.conf"
  local makepkg_config_file="/etc/makepkg.conf"

  # Backup before changing anything.
  sudo cp "$pacman_config_file" "${pacman_config_file}_${DATE}.bak"
  sudo cp "$makepkg_config_file" "${makepkg_config_file}_${DATE}.bak"

  # Enables Color and ParallelDownloads options.
  sudo sed -i 's/^#Color/Color/' "$pacman_config_file"
  sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' "$pacman_config_file"

  # Change AUR build threads to 8. Faster builds on AUR.
  sudo sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/' "$makepkg_config_file"
  
  # Change debug to !debug in OPTIONS. Removes debug packages of AUR installs.
  sudo sed -i 's/OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge debug lto)/ \
  OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)/' "$makepkg_config_file"
}

debloat_archinstall() {
  echo ":: Debloating archinstall"
  sudo pacman -Rns \
    dunst dolphin wofi polkit-kde-agent \
    xorg-xinit htop smartmontools \
    wireless_tools

  sudo pacman -S --dbonly --asdeps \
    qt6-wayland qt5-wayland \
    grim slurp xorg-server libpulse xdg-utils
}

setup_services() {
  echo ":: Setting up services"
  sleep .4

  sudo systemctl enable --now bluetooth.service
  sudo systemctl enable --now NetworkManager.service
}

install_gnome() {
  sudo pacman -Syu
  sudo pacman -S --noconfirm --needed gnome
  sudo pacman -S --dbonly --asdeps \
    tecla gnome-color-manager gnome-keyring \
    gst-plugin-pipewire grilo-plugins \
    gnome-settings-daemon
  sudo pacman -Rns \
    gnome-tour gnome-maps gnome-weather \
    gnome-font-viewer gnome-remote-desktop \
    simple-scan totem orca gnome-user-docs \
    yelp gnome-logs epiphany gnome-contacts \
    gnome-menus malcontent rygel gnome-connections \
    gnome-user-share
  cd /usr/share/wayland-sessions  
  sudo rm -f gnome-classic-wayland.desktop \
      gnome-classic.desktop gnome-wayland.desktop
  cd /usr/share/xsessions
  sudo rm -f gnome-classic-xorg.desktop \
      gnome-classic.desktop gnome-xorg.desktop \
      gnome.desktop
}

setup_hotspot() {
  systemctl enable create_ap
}

setup_autologin() {
  sudo mkdir -p /etc/sddm.conf.d
  sudo echo -e "[Autologin]\nUser=$USER\nSession=hyprland" \
    > /tmp/autologin.conf
  sudo cp /tmp/autologin.conf /etc/sddm.conf.d/
}

backup_flatpak() {
  echo ":: Backing up flatpak applications"
  sleep .4

  flatpak list --app --columns=application >flatpaks.conf
}

finalize() {
  echo ":: Finishing installation"
  sleep .4

  hyprctl reload
  ags --init
}

if [[ "$1" == "--install" ]]; then
  debloat_archinstall
  setup_pacman
  
  install_yay
  rate_mirrors
  install_packages
  install_theme
  
  link_config_folders

  setup_sensors
  setup_user_dirs
  setup_asusctl
  setup_rust
  setup_nemo
  setup_timeshift
  setup_fish
  setup_power_key
  setup_firewall
  setup_bun
  setup_electron
  setup_services
  setup_virtual_network
  setup_hotspot
  
  finalize
  
elif [[ "$1" == "--rate" ]]; then
  rate_mirrors
elif [[ "$1" == "--link" ]]; then
  link_config_folders
elif [[ "$1" == "--yay" ]]; then
  install_yay
elif [[ "$1" == "--autologin" ]]; then
  setup_autologin
elif [[ "$1" == "--flatpak" ]]; then
  backup_flatpak  
fi

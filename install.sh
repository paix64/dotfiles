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

  rate-mirrors --entry-country NL --max-jumps 10 --country-neighbors-per-country 10 \
         --country-test-mirrors-per-country 5 --top-mirrors-number-to-retest 10 --save /tmp/mirrorlist arch
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo mv /tmp/mirrorlist /etc/pacman.d/mirrorlist
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

setup_rust() {
  echo ":: Setting up rust"
  sleep .4

  rustup default stable
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

setup_hotspot() {
  systemctl enable create_ap
}

backup_flatpak() {
  echo ":: Backing up flatpak applications"
  sleep .4

  flatpak list --app --columns=application >flatpaks.conf
}

if [[ "$1" == "" ]]; then
  echo -e "
options:\n  --pacman	setup pacman 
  --rate	rate mirrors
  --link	link dotfiles
  --yay		install yay
  --flatpak	save flatpaks"

elif [[ "$1" == "--pacman" ]]; then
  setup_pacman  
elif [[ "$1" == "--rate" ]]; then
  rate_mirrors
elif [[ "$1" == "--link" ]]; then
  link_config_folders
elif [[ "$1" == "--yay" ]]; then
  install_yay
elif [[ "$1" == "--flatpak" ]]; then
  backup_flatpak  
fi

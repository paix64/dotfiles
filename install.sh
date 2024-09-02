#!/bin/bash

DATE=$(date +%F_%H:%M)

if ! grep -q "arch" /etc/os-release; then
  echo ":: This script is designed to run on Arch Linux."
  exit 1
fi

if [ ! -d "$HOME/dotfiles" ]; then
  echo ":: The directory $HOME/dotfiles does not exist."
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

  yay -Syu --noconfirm --needed
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

  local CHECK_CONFIG_FOLDERS="kitty hypr fastfetch fish oh-my-posh rofi nvim"
  local DATETIME=$(date '+%Y-%m-%d %H:%M:%S')
  local EXISTING="NO"

  mkdir -p "$HOME/.backup/$DATETIME/"

  for dir in $CHECK_CONFIG_FOLDERS; do
    if [ -d "$HOME/.config/$dir" ]; then
      echo ":: Attention: directory $dir already exists in .config"
      mv $HOME/.config/$dir "$HOME/.backup/$DATETIME/"
      EXISTING="YES"
    fi
  done

  if [[ $EXISTING == "YES" ]]; then
    echo ":: Old config folder(s) backed up at ~/.backup folder"
  fi
}

rate_mirrors() {
  echo ":: Rating mirrors"
  sleep .4

  rate-mirrors --save /tmp/mirrorlist arch
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  sudo mv /tmp/mirrorlist /etc/pacman.d/mirrorlist
}

copy_config_folders() {
  check_config_folders

  echo ":: Creating links"
  sleep .4

  ln -s $HOME/dotfiles/kitty $HOME/.config/
  ln -s $HOME/dotfiles/hypr $HOME/.config/
  ln -s $HOME/dotfiles/fish $HOME/.config/
  ln -s $HOME/dotfiles/fastfetch $HOME/.config/
  ln -s $HOME/dotfiles/oh-my-posh $HOME/.config/
  ln -s $HOME/dotfiles/rofi $HOME/.config/
  ln -s $HOME/dotfiles/nvim $HOME/.config/
  ln -s $HOME/dotfiles/wlogout $HOME/.config/
  ln -s $HOME/dotfiles/localshare/zoxide $HOME/.local/share/
  ln -s $HOME/dotfiles/localshare/fish/fish_history $HOME/.local/share/fish/
  ln -s $HOME/dotfiles/wezterm $HOME/.config/
}

setup_services() {
  echo ":: Setting up services"
  sleep .4

  sudo systemctl enable --now bluetooth.service
  echo ":: bluetooth.service activated successfully."

  sudo systemctl enable --now NetworkManager.service
  echo ":: NetworkManager.service activated successfully."
}

update_user_dirs() {
  echo ":: Creating user directories"
  sleep .4

  xdg-user-dirs-update
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
    "schedule_hourly" : "true",
    "schedule_boot" : "true",
    "count_monthly" : "2",
    "count_weekly" : "3",
    "count_daily" : "3",
    "count_hourly" : "3",
    "count_boot" : "3",
    "snapshot_size" : "",
    "snapshot_count" : "",
    "date_format" : "%Y-%m-%d %H:%M:%S",
    "exclude" : [
      "+ /home/$USER/**",
      "+ /root/**"
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
  echo ":: Installing Themes"
  sleep .4

  color_scheme="prefer-dark"
  gtk_theme="Adwaita"
  icon_theme="Papirus-Dark"
  cursor_theme="Bibata-Modern-Ice"

  gsettings set org.gnome.desktop.interface color-scheme $color_scheme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface icon-theme $icon_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme >/dev/null 2>&1 &
  gsettings set org.gnome.desktop.interface font-name "Ubuntu Nerd Font Bold 12" >/dev/null 2>&1 &

  sudo mkdir /etc/sddm.conf.d
  echo "[Theme]
Current=sugar-dark" | sudo tee /etc/sddm.conf.d/theme.conf

  local theme_config="/usr/share/sddm/themes/sugar-dark/theme.conf"
  sudo cp "$theme_config" "${theme_config}_${DATE}.bak"
  sudo sed -i 's/^ForceHideCompletePassword=false/ForceHideCompletePassword=true/' "$theme_config"
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
  local make_config_file="/etc/makepkg.conf"

  sudo cp "$pacman_config_file" "${pacman_config_file}_${DATE}.bak"
  sudo cp "$make_config_file" "${make_config_file}_${DATE}.bak"

  sudo sed -i 's/^#Color/Color/' "$pacman_config_file"
  sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 3/' "$pacman_config_file"

  sudo sed -i 's/^#MAKEFLAGS="-j2"/MAKEFLAGS="-j8"/' "$make_config_file"
  sudo sed -i 's/OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge debug lto)/OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)/' "$make_config_file"
}

finalize() {
  echo ":: Finishing installation"
  sleep .4

  hyprctl reload
  ags --init
}

install_yay
setup_pacman
copy_config_folders

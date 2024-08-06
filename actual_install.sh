#!/bin/bash

install_yay() {
    echo ":: Installing yay..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm --needed
}

rate_mirrors() {
rate-mirrors --save /tmp/mirrorlist arch
sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo mv /tmp/mirrorlist /etc/pacman.d/mirrorlist 
}

ln -s $HOME/dotfiles/ags $HOME/.config/ags
ln -s $HOME/dotfiles/kitty $HOME/.config/kitty
ln -s $HOME/dotfiles/hypr $HOME/.config/hypr
ln -s $HOME/dotfiles/fish $HOME/.config/fish
ln -s $HOME/dotfiles/fastfetch $HOME/.config/fastfetch
ln -s $HOME/dotfiles/oh-my-posh $HOME/.config/oh-my-posh
ln -s $HOME/dotfiles/localshare/zoxide $HOME/.local/share/
ln -s $HOME/dotfiles/rofi $HOME/.config/
ln -s $HOME/dotfiles/nvim $HOME/.config/

install_yay

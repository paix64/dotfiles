#!/bin/bash

install_yay() {
    echo ":: Installing yay..."
    sleep .4
    
    sudo pacman -Syu --noconfirm
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm --needed
}

install_packages() {
	echo ":: Installing packages"
    sleep .4
    
    yay -Syu --noconfirm --needed
    yay -S --needed - < packages.conf
}

setup_sensors() {
	echo ":: Setting up sensors"
	sleep .4
	
    sudo sensors-detect --auto >/dev/null
}

check_config_folders() {
	echo ":: Checking for existing folders"
	sleep .4
	
    local CHECK_CONFIG_FOLDERS="ags kitty hypr fastfetch fish oh-my-posh rofi nvim"
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
	
	ln -s $HOME/dotfiles/ags $HOME/.config/ags
	ln -s $HOME/dotfiles/kitty $HOME/.config/kitty
	ln -s $HOME/dotfiles/hypr $HOME/.config/hypr
	ln -s $HOME/dotfiles/fish $HOME/.config/fish
	ln -s $HOME/dotfiles/fastfetch $HOME/.config/fastfetch
	ln -s $HOME/dotfiles/oh-my-posh $HOME/.config/oh-my-posh
	ln -s $HOME/dotfiles/localshare/zoxide $HOME/.local/share/
	ln -s $HOME/dotfiles/rofi $HOME/.config/
	ln -s $HOME/dotfiles/nvim $HOME/.config/
}

setup_services() {
    echo ":: Setting up services"
    sleep .4

    if systemctl is-active --quiet bluetooth.service; then
        echo ":: bluetooth.service already running."
    else
        sudo systemctl enable bluetooth.service
        sudo systemctl start bluetooth.service
        echo ":: bluetooth.service activated successfully."
    fi

    if systemctl is-active --quiet NetworkManager.service; then
        echo ":: NetworkManager.service already running."
    else
        sudo systemctl enable NetworkManager.service
        sudo systemctl start NetworkManager.service
        echo ":: NetworkManager.service activated successfully."
    fi
}

update_user_dirs() {
    echo ":: Creating user directories"
    sleep .4
    
    xdg-user-dirs-update
}

setup_shell() {
	echo ":: Setting up fish"
	sleep .4
	
	chsh -s $(which fish)
}

setup_firewall() {
	echo ":: Setting up firewall"
	sleep .4
	
	sudo ufw enable
	sudo ufw default deny
	sudo ufw allow from 192.168.0.0/24
	sudo ufw deny ssh

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
	gtk_theme="adw-gtk3-dark"
	icon_theme="Papirus-Dark"
	cursor_theme="Bibata-Modern-Ice"

	gsettings set org.gnome.desktop.interface color-scheme $color_scheme > /dev/null 2>&1 &
	gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme > /dev/null 2>&1 &
	gsettings set org.gnome.desktop.interface icon-theme $icon_theme > /dev/null 2>&1 &
	gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme > /dev/null 2>&1 &
	gsettings set org.gnome.desktop.interface cursor-size 24 > /dev/null 2>&1 & 
	gsettings set org.gnome.desktop.interface font-name "Ubuntu Nerd Font Bold 12" > /dev/null 2>&1 &
}

finalize() {
    echo ":: Finishing installation"
    sleep .4
    
    hyprctl reload
    ags --init
}

install_yay

#! /bin/bash
sudo dnf install gh kitty btop tldr micro rofi vlc variety godot
gh auth login
git clone https://github.com/paixeww/dotfiles.git
cd dotfiles
sudo dnf install stow zsh
stow .
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)
sleep 1
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
flatpak install --user io.github.vikdevelop.SaveDesktop -y
